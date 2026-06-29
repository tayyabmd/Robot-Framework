"""Custom Python keywords for Weather Shopper temperature parsing and price comparison."""
import re
from robot.libraries.BuiltIn import BuiltIn


def parse_temperature(text):
    return int(re.sub(r"[^\d-]", "", text))


def cheapest_index(keyword):
    sl = BuiltIn().get_library_instance("SeleniumLibrary")
    cards = sl.driver.find_elements("css selector", ".text-center.col-4")
    keyword = keyword.lower()
    best_idx, best_price = None, float("inf")
    for i, card in enumerate(cards, start=1):
        name = card.find_element("css selector", "p.font-weight-bold").text.lower()
        if keyword not in name:
            continue
        price_text = next(p.text for p in card.find_elements("tag name", "p") if "Rs." in p.text)
        price = int(re.sub(r"\D", "", price_text))
        if price < best_price:
            best_price, best_idx = price, i
    if best_idx is None:
        raise AssertionError(f"No product found for keyword: {keyword}")
    return best_idx
