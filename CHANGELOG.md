03.07.2024
* Fixed contect missing filtering error in auction list view https://github.com/internetee/auction_center/issues/1281

02.07.2024
* Use comma as a decimal separator https://github.com/internetee/auction_center/issues/1275
* force localise feature for sms confimration https://github.com/internetee/auction_center/pull/1280

28.06.2024
* fixed phone nr confirmation sms request https://github.com/internetee/auction_center/pull/1278

27.06.2024
* prevent offer nil issue in webpush by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/1241
* Enabled partial payments https://github.com/internetee/auction_center/issues/1216
* Translation fixes  https://github.com/internetee/auction_center/pull/1254, https://github.com/internetee/auction_center/pull/1264, https://github.com/internetee/auction_center/pull/1273
* New UI 2023 by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/1102
* added prepend action to format foreign symbols to punicode by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/1274

11.04.2024
* Added auction type to auctions api output https://github.com/internetee/auction_center/issues/1238

12.03.2024
* Removed captcha check from phone confirmation process https://github.com/internetee/auction_center/pull/1230

19.02.2024
* Fixed SMS spamming issue https://github.com/internetee/auction_center/issues/1218

16.02.2024
* Fixed VAT calculation on billing profile change https://github.com/internetee/auction_center/issues/1211

26.01.2024
* Refactored vat rate calculation and fixing logic https://github.com/internetee/auction_center/pull/1194

04.01.2024
* Changed effective time of cookie policy cookie https://github.com/internetee/auction_center/pull/1192
* Fixed vat rate lable in pdf invoices https://github.com/internetee/auction_center/issues/1196
* Quick fix for syncing invoice data with billing https://github.com/internetee/auction_center/pull/1198

13.12.2023
* Auction start and end times are now in user local timezone https://github.com/internetee/auction_center/issues/1187

08.12.2023
* Cookie management improvements: https://github.com/internetee/auction_center/issues/1185

01.12.2023
* LHV-connect support: https://github.com/internetee/auction_center/pull/1180
* Invoice status syncronisation with billing: https://github.com/internetee/auction_center/pull/1183

21.11.2023
* fixed issue with displaying incorrect status notification for a running auction due to timezone differences: https://github.com/internetee/auction_center/issues/1171
* fix for the main menu error in mobile views https://github.com/internetee/auction_center/pull/1184

01.11.2023
* update billing with invoice profile update https://github.com/internetee/auction_center/pull/1181

25.10.2023
* Fixed duplicate deposit record issue https://github.com/internetee/auction_center/pull/1170

11.10.2023
* Added missing attribute name to a validation error message https://github.com/internetee/auction_center/pull/1162
* Fixed registration term info in the automatic email messages https://github.com/internetee/auction_center/issues/1163
* Improved offer lables in mobile view https://github.com/internetee/auction_center/issues/1157

06.10.2023
* Seed file update https://github.com/internetee/auction_center/pull/1158

05.10.2023
* Deposit status syncronisation fix with billing https://github.com/internetee/auction_center/issues/1130

04.10.2023
* Improved AI prompt for sorting active auctions https://github.com/internetee/auction_center/issues/1141
* Fixed issue with too many wishlist notifications in case of open auctions https://github.com/internetee/auction_center/issues/1150
* Fixed JavaScript errors for mobile view https://github.com/internetee/auction_center/issues/1152
* E-invoices are now payable https://github.com/internetee/auction_center/issues/1155

29.09.2023
* Added e-invoicing option https://github.com/internetee/auction_center/issues/1138

25.09.2023
* Added client VAT nr on the invoices https://github.com/internetee/auction_center/issues/1127
* Fixed invoice addressee updating on an invoice https://github.com/internetee/auction_center/issues/1136
* Improved process for adding new billing profile on an invoice https://github.com/internetee/auction_center/issues/1137
* Added VAT code validation https://github.com/internetee/auction_center/issues/1142

22.09.2023
* Removed payment link from overdue invoice emails https://github.com/internetee/auction_center/issues/1129
* Fixed withdrwal information in the portal https://github.com/internetee/auction_center/issues/1143

19.09.2023
* Fix for auction type filter https://github.com/internetee/auction_center/issues/1131
* Fix for auction end extension in case autobidder is updated https://github.com/internetee/auction_center/pull/1132
* Tests for auction end extension https://github.com/internetee/auction_center/pull/1135

18.09.2023
* Fixes for sorting in user and admin views https://github.com/internetee/auction_center/issues/1125

12.09.2023
* Updated informative auction process description on the index page https://github.com/internetee/auction_center/issues/1122

07.09.2023
* Improved reCaptcha handling https://github.com/internetee/auction_center/pull/1117

06.09.2023
* Set localization in url https://github.com/internetee/auction_center/pull/1119

21.08.2023
* Fix for GA4 (Google Analytics) https://github.com/internetee/auction_center/pull/1114

17.08.2023
* Payment order configuration refactoring https://github.com/internetee/auction_center/pull/1107

14.07.2023
* Update Ruby to 3.2.2 https://github.com/internetee/auction_center/pull/1101
* Invoice data of closed invoices is now immutable https://github.com/internetee/auction_center/pull/1088

13.07.2023
* Fix for TARA login CORS error https://github.com/internetee/auction_center/pull/1100

12.07.2023
* Impelemented OpenAI ChatGPT to sort auction list by relative value https://github.com/internetee/auction_center/pull/1098

30.06.2023
* Removed bid and delete offer buttons from finished auctions https://github.com/internetee/auction_center/issues/1094

30.05.2023
* Default order of auctions in the index view is now randomised https://github.com/internetee/auction_center/issues/1080
* fixed invoice payment due date for english auctions https://github.com/internetee/auction_center/issues/1082

15.05.2023
* Small screen view fixes https://github.com/internetee/auction_center/issues/1077
* Et translation for low first bid https://github.com/internetee/auction_center/issues/1078

12.05.2023
* Offer+tax information added to the bid view https://github.com/internetee/auction_center/issues/1072

11.05.2023
* Auction rules section in auction details and your offer views has now english auctin info https://github.com/internetee/auction_center/issues/1063
* Webpush title et translation for outbidding https://github.com/internetee/auction_center/issues/1064
* Still in progress status replaced with winning/loosing statuses for eng auctions https://github.com/internetee/auction_center/issues/1065
* My offers view improvements for Estonian translation https://github.com/internetee/auction_center/issues/1066
* Title fix for my invoices view https://github.com/internetee/auction_center/issues/1067
* Added option to make new bid in my offer view https://github.com/internetee/auction_center/issues/1068
* Session timeout et translation https://github.com/internetee/auction_center/issues/1074

08.05.2023
* Fixed webpush title for the winner https://github.com/internetee/auction_center/issues/1044
* Improved error messages for user creation process https://github.com/internetee/auction_center/issues/1050
* UX improvements for user creation view https://github.com/internetee/auction_center/issues/1054
* Fixed javascript errors https://github.com/internetee/auction_center/pull/1051
* UI improvements to profile view https://github.com/internetee/auction_center/issues/1055
* reCaptcha check is restored https://github.com/internetee/auction_center/pull/1061
* VAT calculation fix for invoices with deposits https://github.com/internetee/auction_center/issues/1060

05.05.2023
* Improved indication of my bids https://github.com/internetee/auction_center/issues/1014
* Translation fixes https://github.com/internetee/auction_center/issues/1020

04.05.2023
* Web push notifications https://github.com/internetee/auction_center/pull/1023
* Handling 0 invoices for auctions with deposit requirement https://github.com/internetee/auction_center/issues/1042

03.05.2023
* Restore the pay all invoices option https://github.com/internetee/auction_center/pull/1046
* Added rake task to change settings in the database https://github.com/internetee/auction_center/issues/1047

02.05.2023
* Temporarily hide pay all invoices option https://github.com/internetee/auction_center/pull/1045

19.04.2023
* Handling of bids over designed upper limit https://github.com/internetee/auction_center/pull/1016

18.04.2023
* Fixed auction and registry syncronisation due to invoicing issues https://github.com/internetee/auction_center/issues/1030

13.04.2023
* Deposit sum added to deposit payment view https://github.com/internetee/auction_center/issues/1029
* Wishlist price sets autobidder for english auctions https://github.com/internetee/auction_center/issues/1031

12.04.2023
* Added translation for denial of deposit and bid payments https://github.com/internetee/auction_center/issues/1028

03.03.2023
* banned users must not be able to make deposit https://github.com/internetee/auction_center/issues/1009
* fixed extra arg in whishlist job https://github.com/internetee/auction_center/pull/1017
* display english auction winning bid in finished auctions list https://github.com/internetee/auction_center/issues/1018

15.02.2023
* fix for nickname issue with autobidder https://github.com/internetee/auction_center/pull/1011

13.02.2023
* websockets for realtime bid updates https://github.com/internetee/auction_center/pull/1008

10.02.2023
* deposit management and autorefund https://github.com/internetee/auction_center/issues/992
* reveal bid history to auction participants https://github.com/internetee/auction_center/issues/999

09.02.2023
* deposits are reset for every auction round https://github.com/internetee/auction_center/issues/991

08.02.2023
* deposit payments are considered as prepayment on invoicing https://github.com/internetee/auction_center/issues/990

31.01.2023
* added list of finished auctions https://github.com/internetee/auction_center/issues/978

20.01.2023
* fixed ban count issue https://github.com/internetee/auction_center/issues/988

16.01.2023
* fixed error in disabling deposit https://github.com/internetee/auction_center/issues/989

13.01.2023
* English auction fixes https://github.com/internetee/auction_center/pull/962

28.12.2022
* List all option for auction listing https://github.com/internetee/auction_center/issues/967

20.12.2022
* Improved sorting in admin for finished auctions https://github.com/internetee/auction_center/pull/981
* Set type to all auctions with missing auction type https://github.com/internetee/auction_center/pull/980

13.12.2022
* Fixed frozen isikukood field issue on user creation https://github.com/internetee/auction_center/issues/973

23.11.2022
* Update dependency pdfkit to v0.8.7 [SECURITY] by @renovate in https://github.com/internetee/auction_center/pull/942
* Update actions/download-artifact action to v3.0.1 by @renovate in https://github.com/internetee/auction_center/pull/947
* Update actions/upload-artifact action to v3.1.1 by @renovate in https://github.com/internetee/auction_center/pull/948
* Update dependency pdfkit to v0.8.7.2 [SECURITY] by @renovate in https://github.com/internetee/auction_center/pull/951
* Bump rails-html-sanitizer from 1.4.1 to 1.4.3 by @dependabot in https://github.com/internetee/auction_center/pull/918
* Bump terser from 5.7.0 to 5.15.1 by @dependabot in https://github.com/internetee/auction_center/pull/953
* Bump omniauth from 1.9.0 to 1.9.2 by @dependabot in https://github.com/internetee/auction_center/pull/928
* Update postgres Docker tag to v15 by @renovate in https://github.com/internetee/auction_center/pull/944
* Bump loader-utils from 1.4.0 to 1.4.1 by @dependabot in https://github.com/internetee/auction_center/pull/952
* fixed ci staging deploy by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/954
* English Auction by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/900
* Broadcast turn off by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/955
* pagy overflow issue handler by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/957
* rollback auction creator by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/958
* 946 incorrect vat calculation by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/949
* Bump socket.io-parser from 4.0.4 to 4.0.5 by @dependabot in https://github.com/internetee/auction_center/pull/956
* Update dependency normalize-url to v8 by @renovate in https://github.com/internetee/auction_center/pull/959
* Update dependency redis to v5 by @renovate in https://github.com/internetee/auction_center/pull/960
* admin order fix by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/963
* Update dependency ssri to v10 by @renovate in https://github.com/internetee/auction_center/pull/961
* Bump loader-utils from 2.0.2 to 2.0.4 by @dependabot in https://github.com/internetee/auction_center/pull/964
* Bump engine.io from 6.2.0 to 6.2.1 by @dependabot in https://github.com/internetee/auction_center/pull/966
* fixed json auction list response by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/969

04.10.2022
* Update dependency postcss-import to v15 by @renovate in https://github.com/internetee/auction_center/pull/935
* Update postgres Docker tag to v14 by @renovate in https://github.com/internetee/auction_center/pull/936
* fix eid sign up by @thiagoyoussef in https://github.com/internetee/auction_center/pull/931
* Allow to delete auctions when does not have any offers by @thiagoyoussef in https://github.com/internetee/auction_center/pull/937
* added warning banner for procedures by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/923
* Add email notification when auto offer is created by @thiagoyoussef in https://github.com/internetee/auction_center/pull/916

09.09.2022
* change total invoice calculation by @OlegPhenomenon in https://github.com/internetee/auction_center/pull/929

05.09.2022
* Fixed accounting export issues in case of deleted account [#915](https://github.com/internetee/auction_center/issues/915)

02.09.2022
* Added integration to billing system [#878](https://github.com/internetee/auction_center/pull/878)

29.08.2022
* Option to add pw and ident code to all user accounts [#467](https://github.com/internetee/auction_center/issues/467)

26.05.2022
* New whislist auto-bid price feature [#893](https://github.com/internetee/auction_center/issues/893)

16.05.2022
* Invoice search and filtering fix for admin [#873](https://github.com/internetee/auction_center/issues/873)

12.05.2022
* Webpacker updated to v 6.0.0 [#809](https://github.com/internetee/auction_center/issues/809)

05.05.2022
* Added system identifier to logs [#853](https://github.com/internetee/auction_center/issues/853)

13.04.2022
* Update dependency css-what to v6 [#862](https://github.com/internetee/auction_center/pull/862)
* Update dependency resolve-url-loader to v5 [#867](https://github.com/internetee/auction_center/pull/867)
* Update actions/checkout action to v3 [#885](https://github.com/internetee/auction_center/pull/885)
* Update actions/download-artifact action to v3 [#886](https://github.com/internetee/auction_center/pull/886)
* Update actions/upload-artifact action to v3 [#887](https://github.com/internetee/auction_center/pull/887)
* Update dependency highcharts to v10 [#888](https://github.com/internetee/auction_center/pull/888)
* Bump puma to 5.6.4 [#891](https://github.com/internetee/auction_center/pull/891)
* Update dependency ssri to v9 [#894](https://github.com/internetee/auction_center/pull/894)
* Bump minimist to 1.2.6 [#895](https://github.com/internetee/auction_center/pull/895)
* Bump nokogiri to 1.13.4 [#896](https://github.com/internetee/auction_center/pull/896)
* Bump ansi-regex [#897](https://github.com/internetee/auction_center/pull/897)
* Update dependency ruby to v3.1.2 [#898](https://github.com/internetee/auction_center/pull/898)

12.02.2022
* Update dependency puma to ~> 5.6.0 [#872](https://github.com/internetee/auction_center/pull/877)

11.02.2022
* Update dependency karma to v6.3.14 [#875](https://github.com/internetee/auction_center/pull/875)

27.01.2022
* Bump follow-redirects to 1.14.7 [#863](https://github.com/internetee/auction_center/pull/863)
* Bump engine.io to 4.1.2 [#864](https://github.com/internetee/auction_center/pull/864)
* Bump nanoid to 3.2.0 [#869](https://github.com/internetee/auction_center/pull/869)
* Bump log4js to 6.4.1 [#872](https://github.com/internetee/auction_center/pull/872)

17.01.2022
* Update auction namespace [#865](https://github.com/internetee/auction_center/pull/865)
* Remove elastic-APM gem [#866](https://github.com/internetee/auction_center/pull/866)

16.12.2021
* Update upload-artifact action to 2.3.1 [#860](https://github.com/internetee/auction_center/pull/860)

25.11.2021
* unsubscribe link to daily auction broadcast emails [#845](https://github.com/internetee/auction_center/issues/845)

06.10.2021
* Invoice nr is now used as order ref for linkpay payments [#836](https://github.com/internetee/auction_center/issues/836)
* Improved error handling and logging for linkpay payments [#838](https://github.com/internetee/auction_center/pull/838)

31.08.2021
* Bump bootsnap to 1.8.1 [#811](https://github.com/internetee/auction_center/pull/811)
* Bump libphonenumber-js to 1.9.25 [#812](https://github.com/internetee/auction_center/pull/812)
* Bump ws to 8.2.1 [#813](https://github.com/internetee/auction_center/pull/813)
* Bump tar to 6.1.11 [#814](https://github.com/internetee/auction_center/pull/814)

26.08.2021
* Refactored linkpay payment confirmation [#808](https://github.com/internetee/auction_center/pull/808)
* Bump highcharts to 9.2.2 [#807](https://github.com/internetee/auction_center/pull/807)

25.08.2021
* Set delay to Linkpay status jobs [#797](https://github.com/internetee/auction_center/pull/797)
* Bump rails to 6.1.4.1 [#799](https://github.com/internetee/auction_center/pull/799)
* Bump webdrivers to 4.6.1 [#800](https://github.com/internetee/auction_center/pull/800)
* Bump listen to 3.7.0 [#801](https://github.com/internetee/auction_center/pull/801)
* Bump webpack-dev-server to 4.0.0 [#802](https://github.com/internetee/auction_center/pull/802)
* Bump ws to 8.2.0 [#803](https://github.com/internetee/auction_center/pull/803)
* Bump browserlist to 4.16.8 [#804](https://github.com/internetee/auction_center/pull/804)
* Bump libphonenumber-js to 19.24 [#805](https://github.com/internetee/auction_center/pull/805)
* Bump rails/webpacker to 5.4.2 [#806](https://github.com/internetee/auction_center/pull/806)

18.08.2021
* Bump bullet to 6.1.5 [#793](https://github.com/internetee/auction_center/pull/793)
* Bump normalize-url to 7.0.1 [#794](https://github.com/internetee/auction_center/pull/794)
* Bump ws to 8.1.0 [#795](https://github.com/internetee/auction_center/pull/795)

11.08.2021
* Fixed logging in production mode [#633](https://github.com/internetee/auction_center/issues/633)
* Bump webmock to 3.14.0 [#788](https://github.com/internetee/auction_center/pull/788)
* Bump browserlist to 4.16.7 [#789](https://github.com/internetee/auction_center/pull/789)
* Bump url-parse to 1.5.3 [#791](https://github.com/internetee/auction_center/pull/791)
* Bump path-parse 1.0.7 [#792](https://github.com/internetee/auction_center/pull/792)

03.08.2021
* Bump bootsnap to 1.7.7 [#781](https://github.com/internetee/auction_center/pull/781)
* Bump puma to 5.4.0 [#782](https://github.com/internetee/auction_center/pull/782)
* Bump ws to 8.0.0 [#783](https://github.com/internetee/auction_center/pull/783)
* Bump libphonenumber-js to 1.9.23 [#784](https://github.com/internetee/auction_center/pull/784)
* Bump tar to 6.1.3 [#785](https://github.com/internetee/auction_center/pull/785)

28.07.2021
* Bump data_migrate to 7.0.2 [#768](https://github.com/internetee/auction_center/pull/768)
* Bump chartkick to 4.0.5 [#770](https://github.com/internetee/auction_center/pull/770)
* Bump normalize-url to 7.0.0 [#773](https://github.com/internetee/auction_center/pull/773)
* removed LinkPay links from auto emails if not configured [#775](https://github.com/internetee/auction_center/pull/775)
* Bump bootsnap to 1.7.6 [#776](https://github.com/internetee/auction_center/pull/776)
* Bump elastic-apm to 4.3.0 [#777](https://github.com/internetee/auction_center/pull/777)
* Bump listen to 3.6.0 [#778](https://github.com/internetee/auction_center/pull/778)
* Bump glob-parent to 6.0.1 [#779](https://github.com/internetee/auction_center/pull/779)
* Bump postcss to 8.3.6 [#780](https://github.com/internetee/auction_center/pull/780)

06.07.2021
* Bump libphonenumber-js to 1.9.21 [#764](https://github.com/internetee/auction_center/pull/764)
* Bump ws to 7.5.2 [#765](https://github.com/internetee/auction_center/pull/765)

29.06.2021
* Bump rails to 6.1.4 [#759](https://github.com/internetee/auction_center/pull/759)
* Bump normalize-url to 6.1.0 [#760](https://github.com/internetee/auction_center/pull/760)
* Bump terser-webpack-plugin to 5.1.4 [#761](https://github.com/internetee/auction_center/pull/761)
* Bump glob-parent to 6.0.0 [#762](https://github.com/internetee/auction_center/pull/762)
* Bump optimize-css-assets-webpack-plugin to 6.0.1 [#763](https://github.com/internetee/auction_center/pull/763)

22.06.2021
* Bump cancancan to 3.3.0 [#749](https://github.com/internetee/auction_center/pull/749)
* Bump ssri to 8.0.1 [#750](https://github.com/internetee/auction_center/pull/750)
* Bump actions/upload-artifact to 2.2.4 [#751](https://github.com/internetee/auction_center/pull/751)
* Bump actions/download-artifact to 2.0.10 [#752](https://github.com/internetee/auction_center/pull/752)
* Bump ws to 7.5.0 [#753](https://github.com/internetee/auction_center/pull/753)
* Bump highcharts to 9.1.2 [#754](https://github.com/internetee/auction_center/pull/754)
* Bump libphonenumber-js to 1.9.20 [#755](https://github.com/internetee/auction_center/pull/755)
* Bump postcss to 8.3.5 [#756](https://github.com/internetee/auction_center/pull/756)
* Bump normalize-url to 6.0.1 [#757](https://github.com/internetee/auction_center/pull/757)

14.06.2021
* Bump karma to 6.3.4 [#745](https://github.com/internetee/auction_center/pull/745)
* Update normalize-url to 4.5.1 [#746](https://github.com/internetee/auction_center/pull/746)
* Update ssri to 6.0.2 [#747](https://github.com/internetee/auction_center/pull/747)

08.06.2021
* Bump ws to 7.4.6 (CVE-2021-32640) [#743](https://github.com/internetee/auction_center/pull/743)
* Bump css-what to 5.0.1 (CVE-2021-33587) [#744](https://github.com/internetee/auction_center/pull/744)
* Bump highcharts from to 9.1.1 [#739](https://github.com/internetee/auction_center/pull/739)
* Bump karma from to 6.3.3 [#740](https://github.com/internetee/auction_center/pull/740)
* Bump qunit from to 2.16.0 [#741](https://github.com/internetee/auction_center/pull/741)
* Bump terser-webpack-plugin from to 5.1.3 [#742](https://github.com/internetee/auction_center/pull/742)

03.06.2021
* changed the api output of registration deadline to indicate last day of the registration instead of release [#2020](https://github.com/internetee/registry/issues/2020)

31.05.2021
* UI improvemnts for canceling bids [#683](https://github.com/internetee/auction_center/issues/683)
* Bump dns-packet 1.3.4 [#732](https://github.com/internetee/auction_center/pull/732)
* Bump cancancan to 3.2.2 [#734](https://github.com/internetee/auction_center/pull/734)
* Bump libphonenumber-js 1.9.19 [#736](https://github.com/internetee/auction_center/pull/736)

24.05.2021
* Bump puma to 5.3.2 [#722](https://github.com/internetee/auction_center/pull/722)
* Bump webmock to 3.13.0 [#723](https://github.com/internetee/auction_center/pull/723)
* Bump simpleidn to 0.2.1 [#725](https://github.com/internetee/auction_center/pull/725)
* Bump mimemagic to 0.4.3 [#726](https://github.com/internetee/auction_center/pull/726)
* Bump libphonenumber.js to 1.19.18 [#727](https://github.com/internetee/auction_center/pull/727)
* Bump rails/webpacker to 5.4.0 [#728](https://github.com/internetee/auction_center/pull/728)

19.05.2021
* Delete offer button translation fix [#684](https://github.com/internetee/auction_center/issues/684)
* Upgrade ruby to 3.0 [#707](https://github.com/internetee/auction_center/pull/707)
* Bump airbrake to 11.0.3 [#698](https://github.com/internetee/auction_center/pull/698)
* Bump money to 6.16.0 [#699](https://github.com/internetee/auction_center/pull/699)
* Bump bootsnap to 1.7.5 [#700](https://github.com/internetee/auction_center/pull/700)
* Bump pry to 0.14.1 [#701](https://github.com/internetee/auction_center/pull/701)
* Bumo data_migrate to 7.0.1 [#702](https://github.com/internetee/auction_center/pull/702)
* Bump optimize-css-assets-webpack-plugin to 6.0.0 [#703](https://github.com/internetee/auction_center/pull/703)
* Bump terser-webpack-plugin to 5.1.2 [#704](https://github.com/internetee/auction_center/pull/704)
* Bump puma to 4.3.8 [#717](https://github.com/internetee/auction_center/pull/717)

12.05.2021
* Added LinkPay feature (paying the invoice using provided unique link) [#606](https://github.com/internetee/auction_center/issues/606)

10.05.2021
* Bump rails to 6.1.3.2 [#679](https://github.com/internetee/auction_center/pull/679)
* Bump okcomputer to 1.18.4 [#674](https://github.com/internetee/auction_center/pull/674)
* Bump bullet to 6.1.4 [#675](https://github.com/internetee/auction_center/pull/675)
* Bump devise to 4.8.0 [#676](https://github.com/internetee/auction_center/pull/676)
* Bump resolve-url-loader to 4.0.0 [#677](https://github.com/internetee/auction_center/pull/677)
* Bump recaptcha to 5.8.0 [#678](https://github.com/internetee/auction_center/pull/678)
* Bump libphonenumber-js to 1.19.7 [#680](https://github.com/internetee/auction_center/pull/680)
* Bump highcharts to 9.1.0 [#681](https://github.com/internetee/auction_center/pull/681)
* Bump rails-ujs to 5.2.6 [#628](https://github.com/internetee/auction_center/pull/682)

06.05.2021
* Is-svg security update to 4.2.2 [#673](https://github.com/internetee/auction_center/pull/673)
* Bump webpacker to 5.3.0 [#671](https://github.com/internetee/auction_center/pull/671)
* Bump resolve-url-loader to 3.1.3 [#672](https://github.com/internetee/auction_center/pull/672)
* Bump listen to 3.5.1 [#669](https://github.com/internetee/auction_center/pull/669)
* Bump data_migrate to 7.0.0 [#668](https://github.com/internetee/auction_center/pull/668)
* Bump chartkick to 4.0.4 [#666](https://github.com/internetee/auction_center/pull/666)
* Bump jbuilder to 2.11.2 [#667](https://github.com/internetee/auction_center/pull/667)
* Bump delayed_job to 4.1.9 [#665](https://github.com/internetee/auction_center/pull/665)

26.04.2021
* Bump simplecom to 0.21.2 [#657](https://github.com/internetee/auction_center/pull/657)
* Bump pdfkit to 0.8.5 [#658](https://github.com/internetee/auction_center/pull/658)
* Bump recaptcha to 5.7.0 [#659](https://github.com/internetee/auction_center/pull/659)
* Bump webmock to 3.12.2 [#660](https://github.com/internetee/auction_center/pull/660)
* Bump bootsnap to 1.7.4 [#661](https://github.com/internetee/auction_center/pull/661)
* Helm charts update: readinessProbe for rails and static container [#656](https://github.com/internetee/auction_center/pull/656)

19.04.2021
* Bump devise to 4.7.3 [#649](https://github.com/internetee/auction_center/pull/649)
* Bump skylight to 5.0.1 [#650](https://github.com/internetee/auction_center/pull/650)
* Bump delayed_job_active_record to 4.1.6 [#651](https://github.com/internetee/auction_center/pull/651)
* Bump capybara to 3.35.3 [#653](https://github.com/internetee/auction_center/pull/653)
* Bump qunit to 2.15.0 [#654](https://github.com/internetee/auction_center/pull/654)
* Updated directo gem [#652](https://github.com/internetee/auction_center/pull/652)

15.04.2021
* Improved search and filtering option in admin [#597](https://github.com/internetee/auction_center/issues/597)

12.04.2021
* Banned users' bids are cancelled [#610](https://github.com/internetee/auction_center/issues/610)
* Bump bootsnap to 1.7.3 [#634](https://github.com/internetee/auction_center/pull/634)
* Bump scenic to 1.5.4 [#635](https://github.com/internetee/auction_center/pull/635)
* Bump chartkick to 4.0.3 [#636](https://github.com/internetee/auction_center/pull/636)
* Bump sprocets to 4.0.2 [#637](https://github.com/internetee/auction_center/pull/637)
* Bump pg to 1.2.3 [#638](https://github.com/internetee/auction_center/pull/638)
* Bump karma to 6.3.2 [#639](https://github.com/internetee/auction_center/pull/639)
* Bump highcharts to 9.0.1 [#640](https://github.com/internetee/auction_center/pull/640)
* Bump chartkick to 4.0.3 [#641](https://github.com/internetee/auction_center/pull/641)
* Bump less to 3.13.1 [#642](https://github.com/internetee/auction_center/pull/642)
* Bump less-loader to 7.3.0 [#643](https://github.com/internetee/auction_center/pull/643)
* Bump upload-artifacts to 2.2.3 [#644](https://github.com/internetee/auction_center/pull/644)
* Bump download-artifacts to 2.0.9 [#645](https://github.com/internetee/auction_center/pull/645)

06.04.2021
* Dependabot and github actions to keep gems updated [#617](https://github.com/internetee/auction_center/pull/617)
* Bump upload-artifact to 2.2.2 [#618](https://github.com/internetee/auction_center/pull/618)
* Bump download-artifact to 2.0.8 [#619](https://github.com/internetee/auction_center/pull/619)
* Bump byebug to 11.1.3 [#620](https://github.com/internetee/auction_center/pull/620)
* Bump web-console to 4.1.0 [#621](https://github.com/internetee/auction_center/pull/621)
* Bump pry to 0.14.0 [#622](https://github.com/internetee/auction_center/pull/622)
* Bump cancancan to 3.2.1 [#623](https://github.com/internetee/auction_center/pull/623)
* Bump webdrivers to 4.6.0 [#624](https://github.com/internetee/auction_center/pull/624)
* Bump typeface-raleway to 1.1.13 [#626](https://github.com/internetee/auction_center/pull/626)
* Bump terser-webpack-plugin to 5.1.1 [#627](https://github.com/internetee/auction_center/pull/627)
* Bump karma-coverage to 2.0.3 [#628](https://github.com/internetee/auction_center/pull/628)
* Added webpack [#630](https://github.com/internetee/auction_center/pull/630)

31.03.2021
* Removed redundant state field from the payment profile view [#612](https://github.com/internetee/auction_center/issues/612)
* Bump y18n to 4.0.1 [#613](https://github.com/internetee/auction_center/pull/613)

24.03.2021
* Fixed ban message on redeeming the last violation [#609](https://github.com/internetee/auction_center/issues/609)

23.03.2021
* Overdue invoices are split into active bans and cancelled groups [#607](https://github.com/internetee/auction_center/issues/607)

18.03.2021
* Added option to redeem invoice due date violations by paying for the invoice after due and releasing the ban [#590](https://github.com/internetee/auction_center/issues/590)

11.03.2021
* Fix for Tara cookie overflow error and airbrake update to 11.0.1 [#604](https://github.com/internetee/auction_center/pull/604)
* Bump elliptic to 5.6.4 [#602](https://github.com/internetee/auction_center/pull/602)

04.03.2021
* Fixed offer total price with no billing profile [#601](https://github.com/internetee/auction_center/issues/601)
* Improved test coverage [#598](https://github.com/internetee/auction_center/issues/598)

25.02.2021
* Optimisation for overuse of memory [#596](https://github.com/internetee/auction_center/pull/596)

19.02.2021
* E-mail template and notification update on failure to pay auction invoices on time [#592](https://github.com/internetee/auction_center/issues/592)

26.01.2021
* Updated Ruby to 2.7.2 [#584](https://github.com/internetee/auction_center/issues/584)
* Bumped socket.io to 2.4.1 [#589](https://github.com/internetee/auction_center/pull/589)
* Switched to GitHub Actions to run autotests [#583](https://github.com/internetee/auction_center/issues/583)

14.01.2021
* Fixed typos in et footer [#585](https://github.com/internetee/auction_center/pull/585)
* Bump Nokogiri to 1.11.1 [#586](https://github.com/internetee/auction_center/pull/586)

17.12.2020
* Bump ini to 1.3.7 [#582](https://github.com/internetee/auction_center/pull/582)

21.10.2020
* Security update on yarn modules [#581](https://github.com/internetee/auction_center/pull/581)

07.10.2020
* Updated Rails to 6.0.3.3 [#580](https://github.com/internetee/auction_center/pull/580)

01.09.2020
* Fix for webpackers memory leakage issue [#579](https://github.com/internetee/auction_center/pull/579)

27.08.2020
* Upgraded webpacker to 5.2 [#576](https://github.com/internetee/auction_center/pull/576)

26.08.2020
* Bump highcharts to 7.2.2 [#577](https://github.com/internetee/auction_center/pull/577)

14.08.2020
* Bump chartkick to 3.4.0 [#575](https://github.com/internetee/auction_center/pull/575)

08.08.2020
* Invoice search by invoice nr in admin [#523](https://github.com/internetee/auction_center/issues/523)

07.08.2020
* Bump json to 2.3.1 [#572](https://github.com/internetee/auction_center/pull/572)
* Bump elliptic to 6.5.3 [#573](https://github.com/internetee/auction_center/pull/573)

17.07.2020
* Bump lodash to 4.17.19 [#571](https://github.com/internetee/auction_center/pull/571)

26.06.2020
* Bump rack to 2.2.3 [#569](https://github.com/internetee/auction_center/pull/569)

08.06.2020
* Bump websocket-extensions to 0.1.5 [#563](https://github.com/internetee/auction_center/pull/563)

02.06.2020
* Fixed healthcheck error handling on http-requests [#560](https://github.com/internetee/auction_center/pull/560)

29.05.2020
* Long payment description are truncated to 94 chars [#546](https://github.com/internetee/auction_center/issues/546)
* Bump kaminari gem to 1.2.1 [#558](https://github.com/internetee/auction_center/pull/558)

28.05.2020
* Sending correct client country code, vat code and vat reg number with invoice info to accounting [#524](https://github.com/internetee/auction_center/issues/524)
* Fix for nomethord error from Process_payments job [#549](https://github.com/internetee/auction_center/issues/549)
* Upgraded Rails gemset to 6.0.3.1 [#556](https://github.com/internetee/auction_center/pull/556)
* Directo gem update [#557](https://github.com/internetee/auction_center/pull/557)

27.05.2020
* Enforced confirmed mobile nr uniqueness checking [#550](https://github.com/internetee/auction_center/issues/550)
* Fixed sorting issue in admin with search criteria applied [#454 ](https://github.com/internetee/auction_center/issues/454)

22.05.2020
* Bump puma to 4.3.5 [#552](https://github.com/internetee/auction_center/pull/552)

11.05.2020
* Auction process due dates are now available over whois and rest-whois [#547](https://github.com/internetee/auction_center/pull/547)

14.04.2020
* Update to Yarn packages due to security vulnerability in minimist [#541](https://github.com/internetee/auction_center/issues/541)

07.04.2020
* Fixed bug with sending invoices without vat code to the accounting system [#544](https://github.com/internetee/auction_center/pull/544)

25.03.2020
* Implemented new Directo gem [#535](https://github.com/internetee/auction_center/pull/535)

20.03.2020
* Rails 6.0.2.2 updated with related gems due to actionview security update [#542](https://github.com/internetee/auction_center/issues/542)

12.03.2020
* Fixed banklink for multi invoice payments [#537](https://github.com/internetee/auction_center/issues/537)

09.03.2020
* Bumped puma gem to version 4.3.3 [#533](https://github.com/internetee/auction_center/pull/533)

28.02.2020
* Fixed header link to regsitrar portal [#530](https://github.com/internetee/auction_center/issues/530)

27.02.2020
* Reference newer directo gem SHA1 commit [#528](https://github.com/internetee/auction_center/pull/528)

21.02.2020
* Added data-migrate gem for automation of data migrations [#513](https://github.com/internetee/auction_center/issues/513)

18.02.2020
* Forced en locale for accounting integration to avoid issues with monetary values [#518](https://github.com/internetee/auction_center/issues/518)

14.02.2020
* Added an option to pay all outstanding invoices at once [#508](https://github.com/internetee/auction_center/issues/508)
* Fixed registry integration test for healtcheck [#512](https://github.com/internetee/auction_center/pull/512)

12.02.2020
* Fixed customercode assigning and improved logging [#514](https://github.com/internetee/auction_center/issues/514)
* Fixed invoice test [#511](https://github.com/internetee/auction_center/pull/511)

10.02.2020
* Removed wkhtmltopdf-binary gem [#509](https://github.com/internetee/auction_center/pull/509)

06.02.2020
* Changed CustomerCode db column in DirectoCustomer to string [#506](https://github.com/internetee/auction_center/pull/506)

05.02.2020
* Accounting customer codes and vat codes must now be unique in the reference db table [#504](https://github.com/internetee/auction_center/pull/504)

04.02.2020
* Restricted list of allowed characters in user and profile forms [#486](https://github.com/internetee/auction_center/issues/486)

28.01.2020
* Improved feedback to user on failed payment attempt [#207](https://github.com/internetee/auction_center/issues/207)
* Logging failed payment attempts [#421](https://github.com/internetee/auction_center/issues/421)

27.01.2020
* Resending registraion reminder if last try failed [#496](https://github.com/internetee/auction_center/issues/496)

24.01.2020
* Option to send daily registration reminders [#266](https://github.com/internetee/auction_center/issues/266)

21.01.2020
* Restructured email locales [#395](https://github.com/internetee/auction_center/issues/395)
* Enabled Estonian personal identity code validation [#490](https://github.com/internetee/auction_center/issues/490)

20.01.2020
* Directo integration [#148](https://github.com/internetee/auction_center/issues/148)

13.01.2020
* Added personal salutaion to automatic emails [#475](https://github.com/internetee/auction_center/issues/475)
* Removed heading tag from salutation of auction emails [#485](https://github.com/internetee/auction_center/pull/485)

10.01.2020
* Improved billing profile management for invoices and active auctions [#313](https://github.com/internetee/auction_center/issues/313)

03.01.2020
* Added autocomplete to wishlist that appends domain extension automatically if none is added [#271](https://github.com/internetee/auction_center/issues/271)
* Changed default sort order to desc at admin interface [#397](https://github.com/internetee/auction_center/issues/397)
* Added integration to Voog for shared page footer [#203](https://github.com/internetee/auction_center/issues/203)

02.01.2020
* Refactored settings [#382](https://github.com/internetee/auction_center/issues/382)
* Fixed timeout error and removed redundant internal API check [#473](https://github.com/internetee/auction_center/issues/473)

30.12.2019
* Registration form UI issues and translation fixes [#462](https://github.com/internetee/auction_center/issues/462)
* Fixed missing auction list checkbox issue in user profile [#465](https://github.com/internetee/auction_center/issues/465)

27.12.2019
* Accounts with unpaid invoices cannot be deleted [#385](https://github.com/internetee/auction_center/issues/385)

19.12.2019
* Added public health check page [#449](https://github.com/internetee/auction_center/pull/449)
* Bump rack from 2.0.7 to 2.0.8 [#463](https://github.com/internetee/auction_center/pull/463)
* Removed reindex_statistics data migration [#460](https://github.com/internetee/auction_center/pull/460)

18.12.2019
* Updated email address change email template [#456](https://github.com/internetee/auction_center/issues/456)

16.12.2019
* Added auction turn count to admin [#289](https://github.com/internetee/auction_center/issues/289)
* Updated serialize-javascript [#447](https://github.com/internetee/auction_center/issues/447)

13.12.2019
* Added basic stats to admin [#174](https://github.com/internetee/auction_center/issues/174)

10.12.2019
* Fixed rounding mode warning for Money gem [#442](https://github.com/internetee/auction_center/issues/442)
* Health check API settings are seeded now [#443](https://github.com/internetee/auction_center/issues/443)

09.12.2019
* Added Health check API documentation [#429](https://github.com/internetee/auction_center/issues/429)

06.12.2019
* Cancelled invoices are now accessible to users [#424](https://github.com/internetee/auction_center/issues/424)
* Removed multi column sorting  in Admin [#408](https://github.com/internetee/auction_center/pull/408)

29.11.2019
* Daily auction list subscription option on auction list view subscribes and unsubscribes now without redirecting user to profile edit view [#428](https://github.com/internetee/auction_center/issues/428)
* Upgrade to Rails 6 [#335](https://github.com/internetee/auction_center/issues/335)

27.11.2019
* Limited the wishlist records to domain extensions registry is responsible for. Partially solves issue #271 [#384](https://github.com/internetee/auction_center/pull/384)

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
