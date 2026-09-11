"""AI-generated GUI added by Codex; the learning script remains diagnostics.py."""
from pathlib import Path
from decimal import Decimal
from queue import Queue, Empty
from threading import Thread
import tkinter as tk
from tkinter import ttk, filedialog, messagebox

import psycopg
from openpyxl import Workbook

SQL_DIR = Path(__file__).resolve().parent.parent / "sql"
REPORTS = {
    "Investigate presentments": "investigate_presentments.sql",
    "Instalments without presentments": "instalments_without_presentments.sql",
    "Outcomes by status": "outcomes_by_status.sql",
}


def fetch_report(filename):
    """Read a known report, returning headings even when there are no rows."""
    if filename not in REPORTS.values():
        raise ValueError("Unknown report")
    query = (SQL_DIR / filename).read_text(encoding="utf-8")
    with psycopg.connect(host="127.0.0.1", port=5432, dbname="ops_demo",
                         user="postgres", connect_timeout=5,
                         options="-c default_transaction_read_only=on -c statement_timeout=15000") as connection:
        with connection.cursor() as cursor:
            cursor.execute(query)
            return [column.name for column in cursor.description], cursor.fetchall()


def save_report(path, columns, rows):
    workbook = Workbook()
    sheet = workbook.active
    sheet.title = "Report"
    sheet.append(columns)
    for row in rows:
        sheet.append(list(row))
        # Database text is exported as text, never as an Excel formula.
        for cell, value in zip(sheet[sheet.max_row], row):
            if isinstance(value, str):
                cell.data_type = "s"
            if isinstance(value, Decimal):
                cell.number_format = '#,##0.00'
    sheet.freeze_panes = "A2"
    sheet.auto_filter.ref = sheet.dimensions
    workbook.save(path)
    workbook.close()


class ReportWindow(ttk.Frame):
    def __init__(self, root):
        super().__init__(root, padding=16)
        self.pack(fill="both", expand=True)
        self.columns, self.rows = [], []
        self.events = Queue()
        self.buttons = []
        self.report_name = ""
        ttk.Label(self, text="Payments diagnostics", font=("Segoe UI", 18, "bold")).pack(anchor="w")
        ttk.Label(self, text="Choose a report to view the current demo data.").pack(anchor="w", pady=(4, 12))
        toolbar = ttk.Frame(self)
        toolbar.pack(fill="x", pady=(0, 12))
        for title, filename in REPORTS.items():
            button = ttk.Button(toolbar, text=title,
                                command=lambda t=title, f=filename: self.run_report(t, f))
            button.pack(side="left", padx=(0, 8))
            self.buttons.append(button)
        self.export_button = ttk.Button(toolbar, text="Export to Excel", command=self.export, state="disabled")
        self.export_button.pack(side="right")
        table_frame = ttk.Frame(self)
        table_frame.pack(fill="both", expand=True)
        table_frame.rowconfigure(0, weight=1)
        table_frame.columnconfigure(0, weight=1)
        self.table = ttk.Treeview(table_frame, show="headings")
        self.table.grid(row=0, column=0, sticky="nsew")
        vertical = ttk.Scrollbar(table_frame, orient="vertical", command=self.table.yview)
        vertical.grid(row=0, column=1, sticky="ns")
        horizontal = ttk.Scrollbar(table_frame, orient="horizontal", command=self.table.xview)
        horizontal.grid(row=1, column=0, sticky="ew")
        self.table.configure(yscrollcommand=vertical.set, xscrollcommand=horizontal.set)
        self.status = tk.StringVar(value="Ready — select a report.")
        ttk.Label(self, textvariable=self.status, wraplength=1000).pack(anchor="w", pady=(12, 0))
        self.after(100, self.poll_results)

    def run_report(self, title, filename):
        self.report_name = title
        self.columns, self.rows = [], []
        self.table.delete(*self.table.get_children())
        self.table.configure(columns=())
        self.export_button.configure(state="disabled")
        for button in self.buttons:
            button.configure(state="disabled")
        self.status.set(f"Loading {title.lower()}…")
        # The worker never touches Tk; results return to the UI through a queue.
        def worker():
            try:
                self.events.put((True, fetch_report(filename)))
            except Exception as error:
                self.events.put((False, str(error)))
        Thread(target=worker, daemon=True).start()

    def poll_results(self):
        try:
            success, payload = self.events.get_nowait()
        except Empty:
            pass
        else:
            for button in self.buttons:
                button.configure(state="normal")
            if success:
                self.columns, self.rows = payload
                self.display_report()
                self.export_button.configure(state="normal")
                self.status.set(f"{self.report_name}: {len(self.rows)} rows returned." if self.rows
                                else f"{self.report_name}: no results found.")
            else:
                self.status.set(f"Report failed: {payload}")
        self.after(100, self.poll_results)

    def display_report(self):
        self.table.configure(columns=self.columns)
        for column in self.columns:
            self.table.heading(column, text=column.replace("_", " ").title())
            self.table.column(column, width=180, minwidth=100, stretch=False)
        for row in self.rows:
            values = ["" if value is None else f"{value:.2f}" if isinstance(value, Decimal)
                      else str(value) for value in row]
            self.table.insert("", "end", values=values)

    def export(self):
        path = filedialog.asksaveasfilename(parent=self, title="Save report", defaultextension=".xlsx",
                                          initialfile=self.report_name.lower().replace(" ", "_") + ".xlsx",
                                          filetypes=[("Excel workbook", "*.xlsx")])
        if not path:
            return
        try:
            save_report(path, self.columns, self.rows)
        except Exception as error:
            messagebox.showerror("Export failed", str(error), parent=self)
        else:
            self.status.set(f"Saved {path}")


def main():
    root = tk.Tk()
    root.title("Payments diagnostics")
    root.geometry("1180x620")
    root.minsize(900, 420)
    ReportWindow(root)
    root.mainloop()


if __name__ == "__main__":
    main()
