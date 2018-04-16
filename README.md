# README

This is a project for having fun. What it does? The first goal is to create a telegram based bot that lets you pay your bills with a couple of text.

If you want to use this code, go ahead. I will make sure to start documenting a little bit more so it becomes usable for anybody.

It all started with this tutorial used https://tutorials.botsfloor.com/full-guide-on-creating-statefull-telegram-bot-523def0a7930

So far the app is a backend that communicates with a telegram bot (see tutorial). When the user talks for the first time it creates a new user on the database and then the bot askes for a couple of questions: so far the bot responds to a few commands to store RUT, phone number and email.

With the "rut" value (Chilean DNI), the bot goes to a Scrapping hub application API that scraps www.unired.cl and gives you the amount that you have in debt for that moment. I will not share the SH app code until it is stable.

Next step: store that debt in the rails app database and then send the amount to the user.
After that: connect with a payment method if the validation of previuos use case is ok (having at least 200 potential users subscribed)