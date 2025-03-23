#!/bin/bash
#
# Locust Test Script for Odoo Performance Testing
# ---------------------------------------------

IMAGE_NAME="odoo-locust-image"
CONTAINER_NAME="odoo-locust"
HOST_DIRECTORY="$(pwd)/tests"

function print_usage {
    echo "Odoo Performance Testing with Locust"
    echo "-----------------------------------"
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  build   Build the Locust Docker image"
    echo "  run     Run Locust (default command)"
    echo "  stop    Stop running Locust container"
    echo "  help    Show Locust help (passes --help to Locust)"
    echo ""
    echo "Options (for run command):"
    echo "  All options are passed directly to Locust. Common options include:"
    echo "  -f, --locustfile FILE   Locust file to run"
    echo "  -u, --users USERS       Number of users to simulate"
    echo "  -r, --spawn-rate RATE   Rate at which users are spawned"
    echo "  -t, --run-time TIME     Stop after the specified time (e.g. 1h30m)"
    echo "  --headless              Run without web UI"
    echo "  --csv=PREFIX            Store results in CSV files with the specified prefix"
    echo ""
    echo "Examples:"
    echo "  $0 build                                        # Build the Docker image"
    echo "  $0 run                                          # Run interactive mode"
    echo "  $0 run -u 50 -r 10                              # Run with 50 users"
    echo "  $0 run --headless -u 100 -r 20 -t 5m            # Run for 5 minutes"
    echo "  $0 run --csv=results -u 50 -r 10                # Save results to CSV"
    echo "  $0 stop                                         # Stop running container"
    echo "  $0 help                                         # Show Locust help"
    echo ""
    exit 1
}

function build_image {
    echo "📦 Building Locust Docker image..."
    mkdir -p "$HOST_DIRECTORY"
    docker build -t "$IMAGE_NAME" -f Dockerfile .
    echo "✅ Locust image built successfully."
}

function run_locust {
    # Check if image exists, build if not
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
        echo "🔍 Locust image not found. Building image first..."
        build_image
    fi

    # Check if container already exists
    if docker ps -a | grep -q "$CONTAINER_NAME"; then
        echo "🧹 Removing existing Locust container..."
        docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1
    fi

    # Make sure locustfile.py exists in the mounted directory
    if [ ! -f "$HOST_DIRECTORY/locustfile.py" ]; then
        echo "⚠️ Warning: locustfile.py not found in the tests directory"
        echo "Expected path: $HOST_DIRECTORY/locustfile.py"
        echo "Continuing anyway, make sure your -f parameter is correct"
    fi

    # Run Docker with Locust - using network=host for direct access to localhost
    echo "🚀 Running Locust with parameters: $*"

    # Convert parameters to an array to handle spaces correctly
    # This ensures parameters with spaces are preserved properly
    params=()
    params+=("-f" "/mnt/locust/locustfile.py")
    for arg in "$@"; do
        params+=("$arg")
    done

    # Check if --detach or -d is in the arguments
    if [[ "$*" == *"--detach"* ]] || [[ "$*" == *" -d "* ]] || [[ "$*" == "-d"* ]]; then
        # Run in detached mode
        docker run --name "$CONTAINER_NAME" -d \
            --network=host \
            -v "$HOST_DIRECTORY:/mnt/locust" \
            "$IMAGE_NAME" "${params[@]}"
        echo "🔄 Locust is running in the background."
        echo "🌐 Access the web interface at: http://localhost:8089"
        echo "❗ To stop Locust: $0 stop"
    else
        # Run in interactive mode (will be removed when stopped with Ctrl+C)
        docker run --rm -it --name "$CONTAINER_NAME" \
            --network=host \
            -v "$HOST_DIRECTORY:/mnt/locust" \
            "$IMAGE_NAME" "${params[@]}"
    fi
}

function show_help {
    # Run Locust with --help to show its help message
    docker run --rm "$IMAGE_NAME" --help
}

function stop_locust {
    if docker ps | grep -q "$CONTAINER_NAME"; then
        echo "🛑 Stopping Locust container..."
        docker stop "$CONTAINER_NAME"
        docker rm "$CONTAINER_NAME"
        echo "✅ Locust container stopped and removed."
    else
        echo "ℹ️ No running Locust container found."
    fi
}

# Parse command
COMMAND="run"
if [ $# -gt 0 ]; then
    case "$1" in
        build)
            COMMAND="$1"
            shift
            ;;
        run)
            COMMAND="$1"
            shift
            ;;
        stop)
            COMMAND="$1"
            shift
            ;;
        help)
            COMMAND="$1"
            shift
            ;;
        -h|--help)
            print_usage
            ;;
    esac
fi

# Execute command
case "$COMMAND" in
    build)
        build_image
        ;;
    run)
        run_locust "$@"
        ;;
    stop)
        stop_locust
        ;;
    help)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        print_usage
        ;;
esac

exit 0