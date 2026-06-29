# Weather Shopper — Robot Framework

End-to-end automation of the [Weather Shopper](https://weathershopper.pythonanywhere.com/) test app using **Robot Framework** + **SeleniumLibrary**, with keyword-driven design and custom Python helpers.

## Flow automated
1. Read temperature; buy moisturizers (<19 °C) or sunscreens (>34 °C).
2. Add cheapest *Aloe* + *Almond* (or *SPF-50* + *SPF-30*).
3. Cart → Stripe iframe checkout → pay with public test card.
4. Assert `PAYMENT SUCCESS`.

> Card `4242 4242 4242 4242` is Stripe's public test card — not a real card.

## Setup & run
```bash
pip install -r requirements.txt
robot --pythonpath resources --outputdir results tests
```

## Stack
Robot Framework · SeleniumLibrary · custom Python keywords · GitHub Actions CI.


<img width="948" height="909" alt="image" src="https://github.com/user-attachments/assets/37f16c97-bef1-4ed8-8adf-0c3b2607f709" />
