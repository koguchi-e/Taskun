document.addEventListener("DOMContentLoaded", () => {
    console.log("✅ DOMContentLoaded: tasks.js がロードされました！ 🚀");

    const messageModal = document.getElementById("messageModal");
    const messageText = document.getElementById("messageText");
    const messageCloseBtn = document.querySelector("#messageModal .close");
    const messageOkBtn = document.getElementById("messageOkBtn");

    if (!messageModal || !messageText || !messageCloseBtn || !messageOkBtn) {
        console.error("⚠️ モーダル要素が正しく取得できていません");
        return;
    }

    // **タスク完了ボタンをクリックしたときの処理**
    document.addEventListener("click", async (event) => {
        const target = event.target.closest(".task-checkbox");
        if (!target) return;

        const taskId = target.dataset.taskId;
        if (!taskId) return;

        console.log("📌 タスク完了ボタンがクリックされました:", taskId);

        const taskElement = target.closest(".index-results");
        const taskTitle = taskElement.querySelector("b");
        const isCurrentlyCompleted = taskElement.classList.contains("completed-task");

        const confirmMessage = isCurrentlyCompleted ? "未完了に戻しますか？" : "タスクを完了しますか？";
        if (!confirm(confirmMessage)) return;

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
            if (data.success) {
                // **完了・未完了のメッセージをモーダルで表示**
                messageText.textContent = isCurrentlyCompleted ? "未完了に戻しました" : "タスクは完了しました";
                messageModal.style.display = "block";

                // **タスクの UI を変更**
                taskElement.classList.toggle("completed-task", !isCurrentlyCompleted);
                taskElement.querySelector("i.fa-circle-check").classList.toggle("completed-icon", !isCurrentlyCompleted);
                taskTitle.classList.toggle("completed-text", !isCurrentlyCompleted);
            } else {
                console.error("❌ サーバーエラー:", data.error || data.errors);
                alert("エラーが発生しました: " + (data.error || data.errors.join(", ")));
            }
        } catch (error) {
            console.error("❌ Fetchエラー:", error);
            alert("タスクの状態変更に失敗しました。");
        }
    });

    // **モーダルを閉じる**
    messageCloseBtn.addEventListener("click", () => {
        messageModal.style.display = "none";
    });

    messageOkBtn.addEventListener("click", () => {
        messageModal.style.display = "none";
    });

    // **モーダル外をクリックで閉じる**
    window.addEventListener("click", (event) => {
        if (event.target === messageModal) {
            messageModal.style.display = "none";
        }
    });
});
