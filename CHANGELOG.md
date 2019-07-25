25.07.2019
* Added Add sorting by highest price and number of offers to portal and admin [#299](https://github.com/internetee/auction_center/pull/299)
* Improved search functionality in admin [#170](https://github.com/internetee/auction_center/issues/170)
* Removed N+1 from auctions index [#128](https://github.com/internetee/auction_center/issues/128)

23.07.2019
* Running Rubocop for test files [#297](https://github.com/internetee/auction_center/pull/297)
* Upgraded Cancan gem to v3.0.1 [#300](https://github.com/internetee/auction_center/pull/300)

22.07.2019
* DejaVu Mono font and colorcoding for numbers in domain names to improve readability [#294](https://github.com/internetee/auction_center/issues/294)
* Fix for security alert and deprecation warning in tests [#298](https://github.com/internetee/auction_center/pull/298)

18.06.2019
* Fixed et minimum offer traslation in offer form [#293](https://github.com/internetee/auction_center/pull/293)
* Added headers for mobile view [#291](https://github.com/internetee/auction_center/pull/291)

14.06.2019
* Added orderable columns to auctions list and most of admin views [#173](https://github.com/internetee/auction_center/issues/173)

12.06.2019
* Added reminder in offer view on how to bid in blind auction [#284](https://github.com/internetee/auction_center/pull/284)
* Enabled use of http poxy for TARA auth integration [#285](https://github.com/internetee/auction_center/pull/285)

07.06.2019
* Omniauth fix for CVE-2015-9284 [#280](https://github.com/internetee/auction_center/pull/280)

06.06.2019
* Added Google Analytics support [#274](https://github.com/internetee/auction_center/issues/274)
* Upgraded webpack to v4 [#277](https://github.com/internetee/auction_center/pull/277)

05.06.2019
* Updated non-critical javascript dependencies [#275](https://github.com/internetee/auction_center/pull/275)

22.05.2019
* New wishlist functionality so no important auction would be missed [#192](https://github.com/internetee/auction_center/issues/192)

17.05.2019
* Added daily admin report (yesterdays results, domains due to be registered tomorrow, new bans) [#267](https://github.com/internetee/auction_center/pull/267) 

08.05.2019
* Updated test dependencies [#263](https://github.com/internetee/auction_center/pull/263)

06.05.2019
* Fixed HTML error on making an offer view [#260](https://github.com/internetee/auction_center/pull/260)
* Disabled country editing for electronically authenticated users [#256](https://github.com/internetee/auction_center/issues/256)
* Readme update about background jobs [#258](https://github.com/internetee/auction_center/pull/258)
* Update Yarn packages [#261](https://github.com/internetee/auction_center/pull/261)

03.05.2019
* jQuery update to 3.4.1 (CVE-2019-11358) [#254](https://github.com/internetee/auction_center/pull/254)
* Fixed test failures that came with newer version of Chrome [#255](https://github.com/internetee/auction_center/pull/255)
* Common dockerfile for deployments [#249](https://github.com/internetee/auction_center/pull/249)

02.05.2019
* Different font for domain names to reduce confusion - applied sys default monospace [#252](https://github.com/internetee/auction_center/pull/252)

29.04.2019
* Reprased payment and registration deadline in Estonian view [#245](https://github.com/internetee/auction_center/issues/245)
* Fixed typo on registration form [#246](https://github.com/internetee/auction_center/issues/246)
* Fixed typo in staging dockerfile [](https://github.com/internetee/auction_center/pull/248)

25.04.2019
* Graceful error handling on multiple invoice payment attempts [#243](https://github.com/internetee/auction_center/pull/243)

24.04.2019
* User's language param is now forwarded on transfering user to payment processor [#238](https://github.com/internetee/auction_center/issues/238)
* Added option for admin to manually mark invoices as paid [#178](https://github.com/internetee/auction_center/issues/178)

23.04.2019
* Nokiri update to 1.10.3 (CVE-2019-11068) and Rails update to 5.2.3 [#235](https://github.com/internetee/auction_center/pull/235)
* Added Invoice payment reminder email functionality [#227](https://github.com/internetee/auction_center/issues/227)

22.04.2019
* Removed thousands' separator from the payment amount sent to payment processors [#231](https://github.com/internetee/auction_center/issues/231)
* Added payment standard references to code [#233](https://github.com/internetee/auction_center/pull/233)

18.04.2019
* Registration checker follows now registration due date to determine when to reauction the domain [#220](https://github.com/internetee/auction_center/issues/220)
* Email address confirmation link expires now in 3 days [#226](https://github.com/internetee/auction_center/pull/226)
* Ban notification text update and ban check optimisation [#202](https://github.com/internetee/auction_center/issues/202)
* Enforced Raleway font everywhere in the application [#223](https://github.com/internetee/auction_center/issues/223)

12.04.2019
* Registration checker uses registration due date for regisration deadline [#220](https://github.com/internetee/auction_center/issues/220)

10.04.2019
* Updated registration code email template [#218](https://github.com/internetee/auction_center/pull/218)
* Added updated by feature for auditing [#216](https://github.com/internetee/auction_center/pull/216)
* Removed obsolete CSS modules [#215](https://github.com/internetee/auction_center/pull/215)

05.04.2019
* Added configurable warning ban setting before full ban is applied [#198](https://github.com/internetee/auction_center/issues/198)
* Removed paiment option from canceled invoices [#210](https://github.com/internetee/auction_center/issues/210)
* Fixed page access errors for users with bans [#201](https://github.com/internetee/auction_center/issues/201)
* Updated payment_term setting description in admin [#211](https://github.com/internetee/auction_center/pull/211)
* Added foreign key constratint to invoice [#213](https://github.com/internetee/auction_center/pull/213)
* Whenever gem removed [#157](https://github.com/internetee/auction_center/issues/157)
* Removed unnecessary Semantic UI modules [#68](https://github.com/internetee/auction_center/issues/68)

03.04.2019
* Updated auction participating reminder in auuction center's header [#191](https://github.com/internetee/auction_center/issues/191)
* Added missing translations to Estonian version of invoice PDF [#197](https://github.com/internetee/auction_center/issues/197)
* Added missing translation for payment instructions on invoice PDF [#169](https://github.com/internetee/auction_center/issues/169)
* New versions of the ban email messages [#194](https://github.com/internetee/auction_center/issues/194)

02.04.2019
* Stop logging passwords to errbit [#190](https://github.com/internetee/auction_center/pull/190)

01.04.2019
* Fixed decimal separator for banklink payments [#188](https://github.com/internetee/auction_center/pull/188)

29.03.2019
* Fixed VAT calculation for Estonian companies [#179](https://github.com/internetee/auction_center/issues/179)
* Vat rate and paid sum is now saved on invoice payment  [#182](https://github.com/internetee/auction_center/pull/182)
* Replaced invoice id with invoice number in invoice view [#177](https://github.com/internetee/auction_center/issues/177)
* Added invoice download option [#147](https://github.com/internetee/auction_center/issues/147)
* Fixed issue where user could generate multiple offers from multiple borwser tabs [#161](https://github.com/internetee/auction_center/pull/161)
* Fixes and improvements to autoemail templates [#162](https://github.com/internetee/auction_center/pull/162)
* Fixed Invoices being randomly in English and Estonian [#164](https://github.com/internetee/auction_center/pull/164)
* Fixed reCaptcha error translation [#168](https://github.com/internetee/auction_center/issues/168)
* Pagination added to invoices [#163](https://github.com/internetee/auction_center/pull/163)
* Moved job triggers away from root url [#166](https://github.com/internetee/auction_center/pull/166)

27.03.2019
* Fixed payment cancellation handling [#154](https://github.com/internetee/auction_center/issues/154)
* Translation fixes for reCaptcha [#153](https://github.com/internetee/auction_center/pull/153)
* Fixed EveryPay decimal place separatpr error [#158](https://github.com/internetee/auction_center/issues/158)

26.03.2019
* Fix translations and text [#120](https://github.com/internetee/auction_center/issues/120)
* Fix some errors [#149](https://github.com/internetee/auction_center/pull/149)
