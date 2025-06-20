import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page.locator("[data-test=\"spotlight-search-input\"]").click()
    page.locator("[data-test=\"spotlight-search\"]").get_by_role("link", name="Artificial Intelligence").click()

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
