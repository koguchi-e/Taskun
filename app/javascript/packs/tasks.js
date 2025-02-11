document.addEventListener("click", async (event) => {
    const target = event.target.closest(".task-checkbox");

    if (!target) return;

    const taskId = target.dataset.taskId;
    if (!taskId) {
        console.error("❌ タスクのIDが見つかりません: taskId=undefined");
        return;
    }

    console.log("📌 タスク完了ボタンがクリックされました:", taskId);

    const messageModal = document.getElementById("messageModal");
    const messageText = document.getElementById("messageText");

    // **モーダルを「処理中」にしてすぐ表示**
    messageText.textContent = "処理中...";
    messageModal.style.display = "flex";
    messageModal.style.justifyContent = "center";
    messageModal.style.alignItems = "center";

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

        if (response.ok && data.success) {
            console.log("✅ タスクが正常に更新されました");

            // **UIを更新**
            const taskElement = target.closest(".index-results");
            const taskTitle = taskElement.querySelector("b");
            const isCompleted = data.completed;
            const completedAt = data.completed_at ? new Date(data.completed_at).toLocaleString("ja-JP") : "未完了";

            taskElement.classList.toggle("completed-task", isCompleted);
            taskElement.querySelector("i.fa-circle-check").classList.toggle("completed-icon", isCompleted);
            taskTitle.classList.toggle("completed-text", isCompleted);

            // **完了日時を表示**
            const completedAtElement = document.getElementById(`completed-at-${taskId}`);
            if (completedAtElement) {
                completedAtElement.textContent = `完了日時: ${completedAt}`;
            }

            // **モーダルのメッセージを更新**
            messageText.textContent = isCompleted ? "タスクは完了しました！" : "未完了に戻しました";

            // **3秒後にモーダルを自動で閉じる**
            setTimeout(() => {
                messageModal.style.display = "none";
            }, 2000);
        } else {
            console.error("❌ タスクの更新に失敗しました:", data.error || data.errors);
            messageText.textContent = "エラーが発生しました";
        }
    } catch (error) {
        console.error("❌ Fetchエラー:", error);
        messageText.textContent = "サーバーエラーが発生しました";
    }
});
