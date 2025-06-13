import threading
from typing import Any, Dict, Optional
from playwright.sync_api import sync_playwright, Playwright, Browser, Page

class ThreadSafePlaywright:
    _instance = None
    _lock = threading.Lock()
    _playwright: Optional[Playwright] = None
    _browser: Optional[Browser] = None
    
    def __init__(self):
        if ThreadSafePlaywright._instance is not None:
            raise Exception("This class is a singleton!")
        else:
            ThreadSafePlaywright._instance = self
    
    @classmethod
    def get_instance(cls) -> 'ThreadSafePlaywright':
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = ThreadSafePlaywright()
        return cls._instance
    
    def initialize(self) -> None:
        with self._lock:
            if self._playwright is None:
                self._playwright = sync_playwright().start()
    
    def get_browser(self, browser_type: str = "chromium", **launch_options: Dict[str, Any]) -> Browser:
        with self._lock:
            if self._browser is None:
                self.initialize()
                self._browser = self._playwright[browser_type].launch(**launch_options)
            return self._browser
    
    def new_page(self, **context_options: Dict[str, Any]) -> Page:
        with self._lock:
            browser = self.get_browser()
            return browser.new_page(**context_options)
    
    def cleanup(self) -> None:
        with self._lock:
            if self._browser:
                self._browser.close()
                self._browser = None
            if self._playwright:
                self._playwright.stop()
                self._playwright = None 