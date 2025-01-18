enum TrafficLightState {

    Red(30), Yellow(5), Green(25);

    final int duration;

    const TrafficLightState(this.duration);

    get waitingTime => this.duration;

}


String getAction(TrafficLightState state) {

     switch (state) {
     	    case TrafficLightState.Red:
	    	 return "State: $state, time: ${state.waitingTime} sec, Action: Stop";
	    case TrafficLightState.Yellow:
	    	 return "State: $state, time: ${state.waitingTime} sec, Action: Slow down";
	    default:
		return "State: $state, time: ${state.waitingTime} sec, Action: Move";
     }
}

Future<void> simulateTraffic() async {

     for (var light in TrafficLightState.values) {
          await Future.delayed(Duration(seconds: light.waitingTime));
	  print('-------------');
          print(getAction(light));
     }

}


void main() {

     var lightState = TrafficLightState.values.forEach((traffic) => print("${traffic.waitingTime} seconds for ${traffic.name}"));

     /*
     for (var light in TrafficLightState.values) {
          print(getAction(light));
     }*/

     simulateTraffic();

}

