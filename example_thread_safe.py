import threading
import time
from thread_safe_playwright import ThreadSafePlaywright

def worker_function(worker_id: int):
    # Get the singleton instance
    playwright = ThreadSafePlaywright.get_instance()
    
    # Get a new page
    page = playwright.new_page()
    
    # Use the page
    page.goto("https://example.com")
    print(f"Worker {worker_id} loaded page: {page.title()}")
    
    # Close the page when done
    page.close()

def main():
    # Create multiple threads
    threads = []
    for i in range(3):
        thread = threading.Thread(target=worker_function, args=(i,))
        threads.append(thread)
        thread.start()
    
    # Wait for all threads to complete
    for thread in threads:
        thread.join()
    
    # Cleanup
    playwright = ThreadSafePlaywright.get_instance()
    playwright.cleanup()

if __name__ == "__main__":
    main() 