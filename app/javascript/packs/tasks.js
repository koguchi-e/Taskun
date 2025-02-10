function initializeTaskEvents() {
    console.log("🔄 タスクのイベントを設定中...");

    // **モーダル要素の取得**
    const messageModal = document.getElementById("messageModal");
    const messageText = document.getElementById("messageText");
    const messageCloseBtn = document.querySelector("#messageModal .close");
    const messageOkBtn = document.getElementById("messageOkBtn");

    if (!messageModal) {
        console.error("❌ messageModal が見つかりません！HTMLを確認してください");
        return;
    }

    if (messageCloseBtn) {
        messageCloseBtn.onclick = () => {
            console.log("🛑 モーダルの × ボタンがクリックされました");
            messageModal.style.display = "none";
        };
    } else {
        console.error("❌ messageCloseBtn が見つかりません！");
    }

    if (messageOkBtn) {
        messageOkBtn.onclick = () => {
            console.log("🛑 モーダルの OK ボタンがクリックされました");
            messageModal.style.display = "none";
        };
    } else {
        console.error("❌ messageOkBtn が見つかりません！");
    }

    // **タスク完了ボタンのクリックイベントを設定**
    document.querySelectorAll(".task-checkbox").forEach((taskCheckbox) => {
        taskCheckbox.replaceWith(taskCheckbox.cloneNode(true));
        const newTaskCheckbox = document.querySelector(`.task-checkbox[data-task-id='${taskCheckbox.dataset.taskId}']`);

        if (!newTaskCheckbox) {
            console.error(`❌ タスクのチェックボックスが見つかりません: taskId=${taskCheckbox.dataset.taskId}`);
            return;
        }

        newTaskCheckbox.addEventListener("click", async (event) => {
            event.stopPropagation();

            const target = event.currentTarget;
            const taskId = target.dataset.taskId;
            if (!taskId) return;

            console.log("📌 タスク完了ボタンがクリックされました:", taskId);

            const taskElement = target.closest(".index-results");
            const taskTitle = taskElement.querySelector("b");

            try {
                const response = await fetch(`/tasks/${taskId}/complete`, { 
                    method: "PATCH",
                    headers: {
                        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                        "Content-Type": "application/json"
                    },
                    credentials: "same-origin"
                });

                const data = await response.json();
                console.log("🔄 サーバーレスポンス:", data);

                if (data.success) {
                    // **サーバーのレスポンスから完了状態を取得**
                    const isCompleted = data.completed;

                    // **モーダルに正しいメッセージを表示**
                    messageText.textContent = isCompleted ? "タスクは完了しました" : "未完了に戻しました";
                    messageModal.style.display = "block";

                    // **タスクの UI を変更**
                    taskElement.classList.toggle("completed-task", isCompleted);
                    taskElement.querySelector("i.fa-circle-check").classList.toggle("completed-icon", isCompleted);
                    taskTitle.classList.toggle("completed-text", isCompleted);
                } else {
                    console.error("❌ サーバーエラー:", data.error || data.errors);
                }
            } catch (error) {
                console.error("❌ Fetchエラー:", error);
            }
        });
    });

    // **モーダル外をクリックで閉じる**
    window.addEventListener("click", (event) => {
        if (event.target === messageModal) {
            console.log("🛑 モーダル外をクリックしたので閉じる");
            messageModal.style.display = "none";
        }
    });
}

// **DOMContentLoadedでイベントを適用**
document.addEventListener("DOMContentLoaded", () => {
    console.log("✅ DOMContentLoaded: tasks.js がロードされました！ 🚀");
    initializeTaskEvents();
});

// **ページネーションでJSを適用し直す**
document.addEventListener("click", (event) => {
    if (event.target.closest(".pagination a")) {
        console.log("📌 ページネーションがクリックされました。JSを適用し直します");
        setTimeout(() => {
            initializeTaskEvents();
        }, 500);
    }
});
