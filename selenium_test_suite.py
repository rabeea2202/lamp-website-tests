# Filename: selenium_test_suite.py
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import time

# Configurations
BASE_URL = "http://174.129.143.204:4000"

def start_driver():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    driver = webdriver.Chrome(options=options)
    driver.get(BASE_URL)
    return driver

def test_page(driver, endpoint):
    driver.get(f"{BASE_URL}/{endpoint}")
    assert "200" in driver.execute_script("return document.readyState") or driver.title != ""

def test_logo_image(driver):
    driver.get(f"{BASE_URL}/index.php")
    try:
        driver.find_element(By.XPATH, "//img[contains(@src, 'Sneaker-logo.jpg')]")
    except NoSuchElementException:
        raise AssertionError("Logo not found")

def test_css_loaded(driver):
    driver.get(f"{BASE_URL}/index.php")
    stylesheets = driver.find_elements(By.TAG_NAME, "link")
    assert any("style.css" in s.get_attribute("href") for s in stylesheets)

def test_keyword_on_homepage(driver):
    driver.get(f"{BASE_URL}/index.php")
    assert "Welcome to SneakerPulse" in driver.page_source

def run_all_tests():
    driver = start_driver()
    try:
        test_page(driver, "index.php")
        test_page(driver, "about.php")
        test_page(driver, "gallery.php")
        test_page(driver, "contact.php")
        test_logo_image(driver)
        test_css_loaded(driver)
        test_keyword_on_homepage(driver)
        print("\u2705 All Selenium UI Tests Passed!")
    finally:
        driver.quit()

if __name__ == '__main__':
    run_all_tests()
