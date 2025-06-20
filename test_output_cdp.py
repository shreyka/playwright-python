import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()
    page.goto("https://suppliernet.walgreens.com/Login.jsp#")
    page.get_by_role("link", name="Login").click()
    page.get_by_role("textbox", name="Enter your OneID").click()
    page.get_by_role("textbox", name="Enter your Password").click()
    page.get_by_role("textbox", name="Enter your OneID").click()
    page.get_by_role("textbox", name="Enter your OneID").fill("fjkdla")
    page.get_by_role("textbox", name="Enter your OneID").press("Tab")
    page.get_by_role("textbox", name="Enter your Password").fill("jfkdla;fjka")
    page.get_by_role("button", name="Sign On").click()

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
