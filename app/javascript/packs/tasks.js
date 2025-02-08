document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".task-checkbox").forEach((checkbox) => {
        checkbox.addEventListener("click", (event) => {
            const taskId = event.currentTarget.dataset.taskId;
            if (!taskId) return; // 他人のタスクはクリック不可

            if (confirm("完了報告しますか？")) {
                fetch(`/tasks/${taskId}/complete`, {
                    method: "PATCH",
                    headers: {
                        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                        "Content-Type": "application/json"
                    },
                    credentials: "same-origin"
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const taskElement = event.currentTarget.closest(".index-results");

                        if (taskElement) {
                            taskElement.classList.add("completed-task"); // タスクの背景色変更
                            event.currentTarget.querySelector("i.fa-circle-check").classList.add("completed-icon"); // チェックアイコンを変更
                            
                            const taskNameElement = taskElement.querySelector(".task-name"); // タスク名の要素を取得
                            if (taskNameElement) {
                                taskNameElement.classList.add("completed-text"); // 取り消し線を適用
                            }
                        }
                    }
                })
                .catch(error => console.error("Error:", error));
            }
        });
    });
});
