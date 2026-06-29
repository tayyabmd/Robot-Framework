*** Settings ***
Library    SeleniumLibrary
Library    keywords.py

*** Variables ***
${URL}              https://weathershopper.pythonanywhere.com/
${BROWSER}          headlesschrome
${EMAIL}            example@gmail.com
${CARD}             4242424242424242
${EXPIRY}           1234
${CVC}              123
${ZIP}              12345

*** Keywords ***
Open Weather Shopper
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Implicit Wait    10s
    Maximize Browser Window

Choose Department By Temperature
    ${temp}=    Get Text    id:temperature
    ${value}=    Parse Temperature    ${temp}
    IF    ${value} < 19
        Click Button    xpath=//button[contains(.,'Buy moisturizers')]
        RETURN    moisturizer
    ELSE
        Click Button    xpath=//button[contains(.,'Buy sunscreens')]
        RETURN    sunscreen
    END

Add Cheapest Product    [Arguments]    ${keyword}
    Wait Until Page Contains Element    css:.text-center.col-4
    ${index}=    Cheapest Index    ${keyword}
    Click Element    xpath=(//div[@class='text-center col-4'])[${index}]//button
    Sleep    0.8s

Go To Cart
    Click Button    xpath=//button[contains(.,'Cart')]

Pay With Card
    Wait Until Page Contains    Pay with Card    20s
    Click Pay With Card

Complete Stripe Checkout
    Wait Until Element Is Visible    xpath=//iframe[@name='stripe_checkout_app']    30s
    Select Frame    xpath=//iframe[@name='stripe_checkout_app']
    Wait Until Element Is Visible    id:email    20s
    Type Slow    email    ${EMAIL}
    Type Slow    card_number    ${CARD}
    Type Slow    cc-exp    ${EXPIRY}
    Type Slow    cc-csc    ${CVC}
    Type Slow    billing-zip    ${ZIP}
    Click Button    id:submitButton
    Unselect Frame

Verify Payment Success
    Wait Until Page Contains    PAYMENT SUCCESS    30s
