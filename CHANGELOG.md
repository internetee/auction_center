26.11.2019
* Fixes response bug if registry integration disabled [#430](https://github.com/internetee/auction_center/pull/430)

25.11.2019
* Added an option for the users to order daily auction list on email [#355](https://github.com/internetee/auction_center/issues/355)

22.11.2019
* Modified ban alert in auction ui to remove references to domain names if these are not being auctioned [#229](https://github.com/internetee/auction_center/issues/229)
* Updated rails-html-sanitizer to 1.3.0 [#426](https://github.com/internetee/auction_center/pull/426)

20.11.2019
* Urls to auction terms and conditions are now localized [#372](https://github.com/internetee/auction_center/issues/372)

18.11.2019
* Big gem versions update [#416](https://github.com/internetee/auction_center/pull/416)

15.11.2019
* Bump loofah from 2.2.3 to 2.3.1 [#407](https://github.com/internetee/auction_center/pull/407)

14.11.2019
* Upgrade Ruby to 2.6.5 [#212](https://github.com/internetee/auction_center/issues/212)
* Added internal health check with API [#343](https://github.com/internetee/auction_center/issues/343)
* Bumps json-jwt from 1.10.0 to 1.11.0 [#412](https://github.com/internetee/auction_center/pull/412)
* Bumps rubyzip from 1.2.3 to 1.3.0 [#415](https://github.com/internetee/auction_center/pull/415)

11.11.2019
* Imroved feedback on email address update in UI [#402](https://github.com/internetee/auction_center/issues/402)

08.11.2019
* Improved test coverage for Estonian identity code validations [#393](https://github.com/internetee/auction_center/pull/393)

06.11.2019
* Fixed ET translation in password change request view [#389](https://github.com/internetee/auction_center/issues/389)
* Fixed ET translation issues in password change form view [#390](https://github.com/internetee/auction_center/issues/390)

05.11.2019
* Admin: replaced 0 value with NaN in auction view highest price column marking auctions with no bids to remove confusion on sorting [#321](https://github.com/internetee/auction_center/issues/321)

01.11.2019
* Admin: users are now ordered from newest to old [#316](https://github.com/internetee/auction_center/issues/316)

29.10.2019
* Bug: Password change confirmation letter is sent again [#167](https://github.com/internetee/auction_center/issues/167)

28.10.2019
* Changed due date constraint on invoices table [#386](https://github.com/internetee/auction_center/pull/386)

22.10.2019
* Fixed multiple error issue in wishlist [#358](https://github.com/internetee/auction_center/issues/358)
* Long domain names are not cut short any more in full and tablet views [#368](https://github.com/internetee/auction_center/issues/368)

15.10.2019
* Fixed mobile view of auction listings [#354](https://github.com/internetee/auction_center/issues/354)

09.10.2019
* English translation improvement to profile view [#361](https://github.com/internetee/auction_center/pull/361)
* Renamed total_amount to paid_amount for clarification [#351](https://github.com/internetee/auction_center/pull/351)

23.09.2019
* Estonian translation improvements [#352](https://github.com/internetee/auction_center/pull/352)

12.09.2019
* Autoupdated devise to 4.7.1 [#349](https://github.com/internetee/auction_center/pull/349)
* Updated reCaptcha gem to 5.1.0 [#345](https://github.com/internetee/auction_center/pull/345)

26.08.2019
* Updatede Nokogiri gem to 1.10.4 (CVE-2019-5477) [#334](https://github.com/internetee/auction_center/pull/334)
* Invoices are now downloaded on click without opening new window first [#317](https://github.com/internetee/auction_center/pull/317)
* HTML fixes [#318](https://github.com/internetee/auction_center/pull/318)
* Improved Google Analytics integration [#319](https://github.com/internetee/auction_center/pull/319)
* Upgraded webdrivers gem to 4.1.2 [#320](https://github.com/internetee/auction_center/pull/320)
* Upgraded capybara gem to 3.28.0 [#322](https://github.com/internetee/auction_center/pull/322)
* Updated delayed_job to 4.1.8 and delayed_job_active_records to 4.1.4 in prep for Rails 6 [#337](https://github.com/internetee/auction_center/pull/337)
* Updated jbuilder gem to 2.9.1 (Rails 6) [#338](https://github.com/internetee/auction_center/pull/338)
* Updated device gem to 4.7.0 (Rails 6) [#339](https://github.com/internetee/auction_center/pull/339)
* Removed selenium-webdriver gem (included in webdrivers gem) [#323](https://github.com/internetee/auction_center/pull/323)
* Gemfile clean up [#324](https://github.com/internetee/auction_center/pull/324)
* Code cleanup - removed unneeded require statements [#326](https://github.com/internetee/auction_center/pull/326)
* Travis config updated for postgresql 9.6 [#331](https://github.com/internetee/auction_center/pull/331)

31.07.2019
* Whishilst now supports punycode so utf8 and their ascii formats are hanled as the same [#270](https://github.com/internetee/auction_center/issues/270)
* Admin: added missing Estonian traslations for invoices column titles [#315](https://github.com/internetee/auction_center/pull/315)

30.07.2019
* Admin: added some missing Estonian translations [#310](https://github.com/internetee/auction_center/pull/310)

29.07.2019
* Admin: fixed filtered views to match corresponding index tables [#307](https://github.com/internetee/auction_center/issues/307)

25.07.2019
* Added Add sorting by highest price and number of offers to portal and admin [#299](https://github.com/internetee/auction_center/pull/299)
* Improved search functionality in admin [#170](https://github.com/internetee/auction_center/issues/170)
* Display used payment channel for paid invoices in admin [#240](https://github.com/internetee/auction_center/issues/240)
* Removed N+1 from auctions index [#128](https://github.com/internetee/auction_center/issues/128)
* Upgraded Less gem to v3.0.0 [#304](https://github.com/internetee/auction_center/pull/304)

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
