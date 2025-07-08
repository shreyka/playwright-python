import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page.locator("[data-test=\"spotlight-search-input\"]").fill("fd")
    page.locator("[data-test=\"spotlight-search-input\"]").click()
    serach = "fda"
    page.locator("[data-test=\"spotlight-search-input\"]").fill(serach)
    fda = page.locator(".box-border > .mx-auto > div").first
    fda.click()

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
