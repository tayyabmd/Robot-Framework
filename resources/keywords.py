"""Custom Python keywords for Weather Shopper.

Mirrors the verified automation logic: product name/price live in the Add
button's ``onclick="addToCart('Name',price)"`` attribute, the Stripe
"Pay with Card" trigger is an injected node, and Stripe's formatted inputs
drop characters unless typed slowly.
"""
import re
import time

from robot.libraries.BuiltIn import BuiltIn


def _driver():
    return BuiltIn().get_library_instance("SeleniumLibrary").driver


def parse_temperature(text):
    return int(re.sub(r"[^\d-]", "", text))


def cheapest_index(keyword):
    cards = _driver().find_elements("css selector", ".text-center.col-4")
    keyword = keyword.lower()
    best_idx, best_price = None, float("inf")
    for i, card in enumerate(cards, start=1):
        button = card.find_element("tag name", "button")
        onclick = (button.get_attribute("onclick") or "").lower()
        if keyword not in onclick:
            continue
        match = re.search(r",\s*(\d+)\s*\)", onclick)
        price = int(match.group(1)) if match else float("inf")
        if price < best_price:
            best_price, best_idx = price, i
    if best_idx is None:
        raise AssertionError(f"No product found for keyword: {keyword}")
    return best_idx


def click_pay_with_card():
    """Click the visible Stripe-injected 'Pay with Card' node."""
    for el in _driver().find_elements("xpath", "//*[contains(text(),'Pay with Card')]"):
        if el.is_displayed():
            el.click()
            return
    raise AssertionError("No visible 'Pay with Card' button found")


def type_slow(element_id, value):
    """Type into an element character-by-character (Stripe-safe)."""
    field = _driver().find_element("id", element_id)
    for char in str(value):
        field.send_keys(char)
        time.sleep(0.08)

