const { Component, useState, onMounted, onWillStart } = owl;
import SlimSelect from "./libdev/slimselect.js";
import { ResultModal, dateToday, fetchJsonData, Rules } from "./gameplay.js";


const SOUND_FAILURE = '/funpill/assets/libdev/cartoon-jump-6462.mp3'
const SOUND_WINNER = '/funpill/assets/libdev/announcement-sound-4-21464.mp3'


export class App extends Component {
    static template = "App";
    static components = { ResultModal, Rules }

    data = []

    state = useState({
        answers_given: [],
        number_of_tries: 5,
        step: 0,
        new_indices: [],
        real_answer: '',
        data: this.data,
        winner: false,
        question: '',
        infos: '',
    });

    setup() {

        onMounted(() => this.attachSelect());

        onWillStart( () => {
            self = this;
            fetchJsonData().then(function(response) {
                const result = response[dateToday()];
                self.state.new_indices.push(result.indices[0]);
                self.data.push(result);
                self.state.question = result.question
            })
        });

    }

    attachSelect() {
        fetchJsonData().then(function (json) {
            let data = []
            let game_data = json[dateToday()]
            for (let i = 0; i < game_data.proposals.length; i++) {
                data.push({text: game_data.proposals[i].value})
            }
            new SlimSelect({
                select: '#proposals',
                placeholder: "Choisis ta réponse ici",
                searchPlaceholder: "Saisir pour rechercher...",
                data: data
            });
        });
    }

    guessAnswer(ev) {
        if (ev.type === "change") {
            let real_answer = this.state.data[0].answer;
            const response = ev.target.value.trim();
            const ans = this.state.data[0].proposals.filter(function (el) {
                return el.value === response
            })
            ev.target.value = "";
            if (this.state.number_of_tries > 0) {
                this.state.answers_given.push(ans[0])
                this.checkAnswer(real_answer, response)
            } else {
                document.getElementById("result-modal").click()
            }
        }
    }

    checkAnswer(real_answer, response) {
        if (real_answer === response) {
            var w_audio = new Audio(SOUND_WINNER);
            w_audio.play();
            this.state.new_indices = this.state.data[0].indices
            document.getElementById("result-modal").click()
            this.state.number_of_tries = 0
            this.state.winner = true
            this.state.real_answer = this.state.data[0].answer
            this.state.infos = this.state.data[0].infos
            party.confetti(document.getElementById("surprise"), {
                shapes: ["square", "circle", "roundedRectangle"],
                count: party.variation.range(300, 500),
                gravity: 800,
                zIndex: 99999,
            });
        } else {
            var f_audio = new Audio(SOUND_FAILURE);
            f_audio.play();
            this.state.number_of_tries--
            this.state.step++
            if (this.state.number_of_tries > 0) {
                this.showNewIndice(this.state.step)
            }
            else if (this.state.number_of_tries === 0) {
                this.state.winner = false
                this.state.real_answer = this.state.data[0].answer
                this.state.infos = this.state.data[0].infos
                document.getElementById("result-modal").click()
            }
        }
    }

    showNewIndice(position) {
        this.state.new_indices.push(this.state.data[0].indices[position])
    }

}
