import { Controller } from "@hotwired/stimulus"
import "vanilla-cookieconsent";

export default class extends Controller {
    connect() {
        var cc = initCookieConsent();

        // run plugin with your configuration
        cc.run({
            current_lang: 'en',
            autoclear_cookies: false,                   // default: false
            page_scripts: true,                        // default: false

            // mode: 'opt-in'                          // default: 'opt-in'; value: 'opt-in' or 'opt-out'
            // delay: 0,                               // default: 0
            auto_language: 'document',                 // default: null; could also be 'browser' or 'document'
            // autorun: true,                          // default: true
            // force_consent: false,                   // default: false
            // hide_from_bots: true,                   // default: true
            // remove_cookie_tables: false             // default: false
            cookie_name: 'cc_cookie',                  // default: 'cc_cookie'
            // cookie_expiration: 182,                 // default: 182 (days)
            // cookie_necessary_only_expiration: 182   // default: disabled
            // cookie_domain: location.hostname,       // default: current domain
            // cookie_path: '/',                       // default: root
            // cookie_same_site: 'Lax',                // default: 'Lax'
            // use_rfc_cookie: false,                  // default: false
            revision: 0,                               // default: 0

            onFirstAction: function(user_preferences, cookie){
                // callback triggered only once on the first accept/reject action
            },

            onAccept: function (cookie) {
                // callback triggered on the first accept/reject action, and after each page load
            },

            onChange: function (cookie, changed_categories) {
                // callback triggered when user changes preferences after consent has already been given
            },

            gui_options: {
                consent_modal: {
                    layout: 'cloud',
                    position: 'bottom center',
                    transition: 'slide',
                    swap_buttons: false,
                },
                settings_modal: {
                    layout: 'box',
                    position: 'right',
                    transition: 'slide',
                },
            },

            languages: {
                en: {
                    consent_modal: {
                        title: 'We use cookies!',
                        description:
                            'To ensure the best user experience for our services, our websites use cookies. We use cookies to personalize content and ads, and to provide social media features. We ask for your permission to use cookies that are not necessarily essential for the basic functions of our website. Please read our detailed descriptions and rules of cookies <a class="cc__link" href="https://www.internet.ee/eif/cookies-on-internet-ee-webpage" target="_blank">here</a>.',
                        primary_btn: {
                            text: 'ACCEPT ALL',
                            role: 'accept_all', // 'accept_selected' or 'accept_all'
                        },
                        secondary_btn: {
                            text: 'SETTINGS',
                            role: 'settings', // 'settings' or 'accept_necessary'
                        },
                    },
                    settings_modal: {
                        title: 'Cookie Settings',
                        save_settings_btn: 'SAVE SETTINGS',
                        accept_all_btn: 'ACCEPT ALL',
                        reject_all_btn: 'REJECT ALL',
                        close_btn_label: 'Close',
                        // cookie_table_headers: [
                        //     { col1: 'Name' },
                        //     { col2: 'Domain' },
                        //     { col3: 'Expiration' },
                        //     { col4: 'Description' },
                        // ],
                        blocks: [
                            {
                                title: 'Cookie usage',
                                description:
                                    'We use cookies to help you navigate efficiently and perform certain functions. You will find detailed information about all cookies under each consent category below. The cookies that are categorized as "Necessary" are stored on your browser as they are essential for enabling the basic functionalities of the site.',
                            },
                            {
                                title: 'Strictly necessary cookies',
                                description:
                                    'Help us make the website more user-friendly by activating essential functions. The website cannot function properly without these cookies. As these cookies are needed for the secure provision of services, the visitor cannot refuse them.',
                                toggle: {
                                    value: 'necessary',
                                    enabled: true,
                                    readonly: true, // cookie categories with readonly=true are all treated as "necessary cookies"
                                },
                                // cookie_table: [
                                //     // list of all expected cookies
                                //     {
                                //         col1: '_registrar_center2_session',
                                //         col2: 'registrar.internet.ee',
                                //         col3: 'At the end of the session',
                                //         col4: 'Session cookie used by web application for maintaining session state for a user.',
                                //         is_regex: true,
                                //     },
                                //     {
                                //         col1: 'request_ip',
                                //         col2: 'registrar.internet.ee',
                                //         col3: '1 day',
                                //         col4: "Used to store the IP address of the user's request for various purposes, like rate limiting or logging in.",
                                //     },
                                //     {
                                //         col1: 'locale',
                                //         col2: 'registrar.internet.ee',
                                //         col3: '2 years',
                                //         col4: "Used to store the user's preferred language setting.",
                                //     },
                                // ],
                            },
                            {
                                title: 'Statistics and Analytics Cookies',
                                description:
                                'Help us understand how a specific visitor uses the website. This way we see how many people visit the site during a certain period, how they navigate through web pages, and what they click on. These cookies provide us with information based on which we improve the customer experience.',
                                toggle: {
                                    value: 'analytics',
                                    enabled: true,
                                    readonly: false, // cookie categories with readonly=true are all treated as "necessary cookies"
                                },
                            }
                        ],
                    },
                },
                et: {
                    consent_modal: {
                        title: 'Kasutame küpsiseid!',
                        description:
                            'Meie teenuste parima kasutajakogemuse tagamiseks kasutavad meie veebisaidid küpsiseid. Kasutame küpsiseid sisu ja reklaamide isikupärastamiseks, sotsiaalse meedia funktsioonide pakkumiseks. Küsime sinult luba, et kasutada küpsiseid, mis ei ole tingimata vajalikud meie veebilehe põhifunktsioonide toimimiseks. Palun loe meie küpsiste üksikasjalikke kirjeldusi ja reegleid <a class="cc__link" href="https://www.internet.ee/eis/kupsised-internet-ee-lehel" target="_blank">siit</a>.',
                        primary_btn: {
                            text: 'LUBA KÕIK',
                            role: 'accept_all', // 'accept_selected' or 'accept_all'
                        },
                        secondary_btn: {
                            text: 'SEADISTUSED',
                            role: 'settings', // 'settings' or 'accept_necessary'
                        },
                    },
                    settings_modal: {
                        title: 'Küpsiste seaded',
                        save_settings_btn: 'SALVESTA',
                        accept_all_btn: 'LUBA KÕIK',
                        reject_all_btn: 'KEELA KÕIK',
                        close_btn_label: 'Sulge',
                        // cookie_table_headers: [
                        //     { col1: 'Nimi' },
                        //     { col2: 'Domeen' },
                        //     { col3: 'Kehtivus' },
                        //     { col4: 'Kirjeldus' },
                        // ],
                        blocks: [
                            {
                                title: 'Küpsiste kasutamine',
                                description:
                                    'Kasutame küpsiseid, et aidata Teil tõhusalt navigeerida ja teatud funktsioone täita. Üksikasjalikku teavet kõigi küpsiste kohta leiate allpool iga nõusolekukategooria alt. Küpsistest, mis on liigitatud kui "Vajalikud" ei saa loobuda, sest need on olulised saidi põhifunktsioonide toimimiseks.',
                            },
                            {
                                title: 'Vajalikud küpsised',
                                description:
                                    'Veebileht ei saa ilma nende küpsisteta korralikult toimida. Seetõttu ei ole külastajal võimalik neist keelduda.',
                                toggle: {
                                    value: 'necessary',
                                    enabled: true,
                                    readonly: true, // cookie categories with readonly=true are all treated as "necessary cookies"
                                },
                                // cookie_table: [
                                //     // list of all expected cookies
                                //     {
                                //         col1: '_registrar_center2_session',
                                //         col2: 'registrar.internet.ee',
                                //         col3: 'Sessiooni lõpus',
                                //         col4: 'Sessiooni küpsis, mida veebirakendus kasutab kasutaja seansi oleku säilitamiseks.',
                                //         is_regex: true,
                                //     },
                                //     {
                                //         col1: 'request_ip',
                                //         col2: 'registrar.internet.ee',
                                //         col3: '1 päev',
                                //         col4: "Kasutatakse kasutaja päringu IP-aadressi salvestamiseks mitmesugustel eesmärkidel, nagu rate limiting või sisselogimine.",
                                //     },
                                //     {
                                //         col1: 'locale',
                                //         col2: 'registrar.internet.ee',
                                //         col3: '2 aastat',
                                //         col4: "Kasutatakse kasutaja eelistatud keeleseade salvestamiseks.",
                                //     },
                                // ],
                            },
                            {
                                title: 'Statistics and Analytics Cookies',
                                description:
                                'Aitavad meil mõista, kuidas konkreetne külastaja veebilehte kasutab. Nii näeme, kui palju inimesi kindlal ajavahemikul lehte külastab, kuidas veebilehtedel liigutakse ja millele klikitakse. Need küpsised annavad meile infot, mille põhjal parendada kliendikogemust.',
                                toggle: {
                                    value: 'analytics',
                                    enabled: true,
                                    readonly: false, // cookie categories with readonly=true are all treated as "necessary cookies"
                                },
                            }
                        ],
                    },
                },
            },
        });
    }
}
