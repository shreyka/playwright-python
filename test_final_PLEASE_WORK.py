import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page.get_by_role("link", name="Login").click()
    Testing = "hello"
    page.get_by_role("textbox", name="Enter your OneID").fill(Testing)
    page.get_by_role("textbox", name="Enter your OneID").press("Tab")

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
