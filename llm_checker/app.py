from flask import Flask, render_template, jsonify, request

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('premium.html')

@app.route('/api/analyze', methods=['POST'])
def analyze():
    try:
        specs = request.get_json()
        ram_gb = float(specs.get('ram_gb', 0))
        
        compatibility = {
            'tiny_models': {
                'compatible': ram_gb >= 8,
                'models': ['TinyLlama (1.1B)', 'Phi-2 (2.7B)']
            },
            'small_models': {
                'compatible': ram_gb >= 12,
                'models': ['Mistral 7B (4-bit)', 'LLaMA2 7B (4-bit)']
            },
            'medium_models': {
                'compatible': ram_gb >= 16,
                'models': ['LLaMA2 13B (4-bit)']
            }
        }
        
        return jsonify({
            'specs': specs,
            'compatibility': compatibility
        })

    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)