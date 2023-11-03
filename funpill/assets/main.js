const { mount } = owl;
import { App } from './app.js';


/**
 * Setup
 */
async function start() {
  console.log("App running on OWL ", owl.__info__);
  const TEMPLATES = await owl.loadFile("/funpill/assets/templates.xml");
  const env = { TEMPLATES };
  mount(App, document.querySelector("#app"), { templates: TEMPLATES });
}

start();
