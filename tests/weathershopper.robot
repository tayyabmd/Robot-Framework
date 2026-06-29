*** Settings ***
Resource    ../resources/keywords.robot
Test Teardown    Close Browser

*** Test Cases ***
Buy Cheapest Products And Pay
    Open Weather Shopper
    ${dept}=    Choose Department By Temperature
    IF    '${dept}' == 'moisturizer'
        Add Cheapest Product    aloe
        Add Cheapest Product    almond
    ELSE
        Add Cheapest Product    spf-50
        Add Cheapest Product    spf-30
    END
    Go To Cart
    Pay With Card
    Complete Stripe Checkout
    Verify Payment Success
