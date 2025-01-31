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
        gpu = specs.get('gpu', '').lower()
        cpu_cores = int(specs.get('cpu_cores', 0))
        
        # Detect NVIDIA GPU and VRAM
        has_nvidia = any(brand in gpu for brand in ['nvidia', 'rtx', 'gtx'])
        vram_gb = 0
        if 'rtx 4090' in gpu: vram_gb = 24
        elif 'rtx 3090' in gpu: vram_gb = 24
        elif 'rtx 3080' in gpu: vram_gb = 12
        elif 'rtx 3070' in gpu: vram_gb = 8
        
        compatibility = {
            'tiny_models': {
                'compatible': ram_gb >= 8,
                'models': ['TinyLlama (1.1B)', 'Phi-2 (2.7B)'],
                'requirements': {
                    'ram': '8GB',
                    'vram': 'Integrated GPU OK',
                    'cpu': '4+ cores'
                }
            },
            'small_models': {
                'compatible': ram_gb >= 16,
                'models': ['Mistral 7B (4-bit)', 'LLaMA2 7B (4-bit)'],
                'requirements': {
                    'ram': '16GB',
                    'vram': '4GB+',
                    'cpu': '6+ cores'
                }
            },
            'medium_models': {
                'compatible': ram_gb >= 32 and vram_gb >= 8,
                'models': ['LLaMA2 13B (4-bit)', 'Mixtral 8x7B (Q4)'],
                'requirements': {
                    'ram': '32GB',
                    'vram': '8GB (RTX 3070+)',
                    'cpu': '8+ cores'
                }
            },
            'large_models': {
                'compatible': ram_gb >= 64 and vram_gb >= 16,
                'models': ['LLaMA2 70B (4-bit)', 'Claude-on-Ethereum'],
                'requirements': {
                    'ram': '64GB',
                    'vram': '16GB (RTX 4090)',
                    'cpu': '8+ cores, AVX2'
                }
            }
        }

        # Generate upgrade recommendations
        recommendations = []
        
        if ram_gb < 16:
            recommendations.append({
                'type': 'ram',
                'message': 'Upgrade to 16GB RAM to run basic models',
                'urgency': 'high'
            })
        elif ram_gb < 32:
            recommendations.append({
                'type': 'ram',
                'message': 'Consider 32GB RAM for medium models',
                'urgency': 'medium'
            })
        elif ram_gb < 64:
            recommendations.append({
                'type': 'ram',
                'message': '64GB RAM recommended for large models',
                'urgency': 'low'
            })

        if not has_nvidia:
            recommendations.append({
                'type': 'gpu',
                'message': 'NVIDIA GPU required for optimal performance',
                'urgency': 'high'
            })
        elif vram_gb < 8:
            recommendations.append({
                'type': 'gpu',
                'message': 'RTX 3070 or better recommended for medium models',
                'urgency': 'medium'
            })
        elif vram_gb < 16:
            recommendations.append({
                'type': 'gpu',
                'message': 'RTX 4090 recommended for large models',
                'urgency': 'low'
            })

        if cpu_cores < 8:
            recommendations.append({
                'type': 'cpu',
                'message': '8+ core CPU recommended for better performance',
                'urgency': 'medium'
            })
            
        return jsonify({
            'specs': specs,
            'compatibility': compatibility,
            'recommendations': recommendations
        })

    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)