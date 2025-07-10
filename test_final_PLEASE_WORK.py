import re
from playwright.sync_api import Playwright, sync_playwright, expect


def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page.locator("div").filter(has_text=re.compile(r"^Promotion$")).nth(1).click()
    promotion_group = page.get_by_text("Promotion Management")
    promotion_group.click()

    # ---------------------
    context.close()
    browser.close()


with sync_playwright() as playwright:
    run(playwright)
