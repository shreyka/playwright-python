import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page.screenshot(path="screenshot-1754979577254.png")
    page.locator("[data-test=\"spotlight-search-input\"]").click()
    test = "testing"
    page.locator("[data-test=\"spotlight-search-input\"]").fill(test)
    page.screenshot(path="screenshot-1754979577254.png")
    page.screenshot(path="screenshot-1754979577254.png")

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
