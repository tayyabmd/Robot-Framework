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
    ${index}=    Cheapest Index    ${keyword}
    Click Element    xpath=(//div[@class='text-center col-4'])[${index}]//button

Go To Cart
    Click Button    xpath=//button[contains(.,'Cart')]

Pay With Card
    Click Button    xpath=//button[contains(.,'Pay with Card')]

Complete Stripe Checkout
    Wait Until Element Is Visible    xpath=//iframe[@name='stripe_checkout_app']    30s
    Select Frame    xpath=//iframe[@name='stripe_checkout_app']
    Input Text    id:email    ${EMAIL}
    Input Text    id:card_number    ${CARD}
    Input Text    id:cc-exp    ${EXPIRY}
    Input Text    id:cc-csc    ${CVC}
    Input Text    id:billing-zip    ${ZIP}
    Click Button    xpath=//button[contains(.,'Pay')]
    Unselect Frame

Verify Payment Success
    Wait Until Page Contains    PAYMENT SUCCESS    30s
