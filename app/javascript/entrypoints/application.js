// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log('Vite ⚡️ Rails')

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

console.log('Visit the guide for more information: ', 'https://vite-ruby.netlify.app/guide/rails')

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'

import { createApp, h } from "vue";
import { createInertiaApp } from "@inertiajs/vue3";
import PrimeVue from "primevue/config";
import Aura from "@primevue/themes/aura";
import InputText from "primevue/inputtext";
import FloatLabel from "primevue/floatlabel";
import Textarea from "primevue/textarea";
import SelectButton from "primevue/selectbutton";
import DataView from "primevue/dataview";
import Button from "primevue/button";
import Tag from "primevue/tag";
//import Admin from '../Layouts/Admin.vue'
import Main from '../Layouts/Main.vue'
import Card from 'primevue/card';
import Select from 'primevue/select';
import Paginator from 'primevue/paginator';
import Checkbox from 'primevue/checkbox'
import InputNumber from 'primevue/inputnumber';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Accordion from 'primevue/accordion';
import AccordionPanel from 'primevue/accordionpanel';
import AccordionHeader from 'primevue/accordionheader';
import AccordionContent from 'primevue/accordioncontent';
import Badge from 'primevue/badge';
import { RadioButton } from "primevue";


//import { createPinia } from 'pinia';
//const pinia = createPinia()

import Listbox from 'primevue/listbox';

import 'primeicons/primeicons.css'
//import { useUserStore } from "../stores/userStore";

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob("../Pages/**/*.vue", { eager: true });
    return pages[`../Pages/${name}.vue`];
  },
  setup({ el, App, props, plugin }) {
    createApp({
      render: () => {
        // const current_user = props.initialPage.props['current_user']
        //   useUserStore().insertUser(current_user)
        //   console.log({current_user})
        return h(App, props)
      }
    })
      .use(plugin)
      //.use(pinia)
      .use(PrimeVue, {
        theme: {
          preset: Aura,
        },
      })
      .component("InputText", InputText)
      .component("InputNumber", InputNumber)
      .component("FloatLabel", FloatLabel)
      .component("Textarea", Textarea)
      .component("SelectButton", SelectButton)
      .component("DataView", DataView)
      .component("Button", Button)
      .component("Card", Card)
      .component("Tag", Tag)
      .component("Badge", Badge)
      .component("Checkbox", Checkbox)
      .component("Listbox", Listbox)
      .component("Main", Main)
      .component("RadioButton", RadioButton)
      .component("Column", Column)
      .component("DataTable", DataTable)
      .component("Select", Select)
      .component("Paginator", Paginator)
      .component("Accordion", Accordion)
      .component("AccordionPanel", AccordionPanel)
      .component("AccordionContent", AccordionContent)
      .component("AccordionHeader", AccordionHeader)
      .mount(el);
  },
});

