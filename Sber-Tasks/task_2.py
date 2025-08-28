from flask import Flask, Response,request, render_template, url_for, jsonify
import requests
app = Flask(__name__)


tasks = []
task_counter = 1


@app.route('/tasks', methods=['GET'])
def get_task():
    return jsonify(tasks),200


@app.route('/tasks', methods=['POST'])
def add_task():
    global task_counter
    
    data = request.get_json()
    if not data or "title" not in data:
        return jsonify({"error": "Поле 'title' обязательно"}),400
    
    new_task={
        "id": task_counter,
        "title": data["title"],
        "completed": data.get("completed",False)
    }
    tasks.append(new_task)
    task_counter += 1
    return jsonify(new_task), 201


@app.route('/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    global tasks
    task = next((t for t in tasks if t["id"] == task_id),None)
    
    if task is None:
        return jsonify({"error": f"Задача с id={task_id} не найдена"}), 404
    tasks = [t for t in tasks if t["id"] != task_id]
    
    return jsonify({"message": f"Задача {task_id} удалена"}), 200

# @app.route('/', methods = ['POST'])
# def webhook():
#     incoming_msg = request.values.ge
#     resp = MessagingResponse()
#     msg = resp.message()




if __name__ == "__main__":
    
    app.run(debug=True)
    