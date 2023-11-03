const { Component, useState, onMounted } = owl;

const ENDPOINT = '/funpill/assets/game_data.json';

export function dateToday() {
    const date = new Date();
    const year = date.getFullYear();
    let month = date.getMonth() + 1; // Months start at 0!
    let day = date.getDate();

    if (day < 10) day = '0' + day;
    if (month < 10) month = '0' + month;

    return `${year}-${month}-${day}`
}

export async function fetchJsonData() {
  const response = await fetch(ENDPOINT);
  const data = await response.json();
  return data
}

export function countDown(state) {
    // Set the date we're counting down to
    const limitDate = new Date();
    limitDate.setHours(24,0,0,0);

    // Update the count down every 1 second
    const x = setInterval(function() {

        const now = new Date().getTime();

        // Find the distance between now and the count down date
        const distance = limitDate - now;

        // Time calculations for hours, minutes and seconds
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        state.timer_down = hours + "h " + minutes + "m " + seconds + "s ";

        // If the count down is over, reset
        if (distance < 0) {
            clearInterval(x);
            state.timer_down = "---"
        }
    }, 1000);
};


export function getRandomInt(min, max) {
    // Return and integer in intervall [min; max[
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min);
};


function getRandomGif(state, min, max) {
    state.gif_img = getRandomInt(min, max).toString()
}


export class Timer extends Component {
    static template = 'Timer'

}


export class GifImage extends Component {
    static template = 'GifImage'

}


export class ResultModal extends Component {
    static template = 'ResultModal'
    static components = { Timer, GifImage }

    setup() {
        this.state = useState({
            timer_down: '',
            gif_img: '',
            tweet: 'Trouve le FunPill 🟢🟣💊 du jour et découvre un gif marrant 🤣 sur www.peef.dev/funpill @peef_dev'
        });
        countDown(this.state)
        getRandomGif(this.state, 1, 24)
    }

}


export class Statistics extends Component {
    static template = 'Statistics'
}


export class Rules extends Component {
    static template = 'Rules'
}
