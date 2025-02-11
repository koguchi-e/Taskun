document.addEventListener("click", async (event) => {
    const target = event.target.closest(".task-checkbox");

    if (!target) return;

    const taskId = target.dataset.taskId;
    if (!taskId) {
        console.error("❌ タスクのIDが見つかりません: taskId=undefined");
        return;
    }

    console.log("📌 タスク完了ボタンがクリックされました:", taskId);

    try {
        const response = await fetch(`/tasks/${taskId}/complete`, {
            method: "PATCH",
            headers: {
                "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                "Content-Type": "application/json"
            },
            credentials: "same-origin"
        });

        // **レスポンスの Content-Type をチェック**
        const contentType = response.headers.get("content-type");
        if (!contentType || !contentType.includes("application/json")) {
            console.error("❌ サーバーが JSON を返していません。HTML が返ってきた可能性があります。");
            const errorText = await response.text();
            console.error("サーバーレスポンス:", errorText);
            return;
        }

        const data = await response.json();
        console.log("🔄 サーバーレスポンス:", data);

        if (response.ok && data.success) {
            console.log("✅ タスクが正常に更新されました");

            // **UIを更新**
            const taskElement = target.closest(".index-results");
            const taskTitle = taskElement.querySelector("b");
            const isCompleted = data.completed;

            taskElement.classList.toggle("completed-task", isCompleted);
            taskElement.querySelector("i.fa-circle-check").classList.toggle("completed-icon", isCompleted);
            taskTitle.classList.toggle("completed-text", isCompleted);

            // **モーダル表示**
            document.getElementById("messageText").textContent = isCompleted ? "タスクは完了しました" : "未完了に戻しました";
            const messageModal = document.getElementById("messageModal");
            messageModal.style.display = "flex";
            messageModal.style.justifyContent = "center";
            messageModal.style.alignItems = "center";

            // **3秒後にモーダルを自動で閉じる**
            setTimeout(() => {
                messageModal.style.display = "none";
            }, 3000);
        } else {
            console.error("❌ タスクの更新に失敗しました:", data.error || data.errors);
        }
    } catch (error) {
        console.error("❌ Fetchエラー:", error);
    }
});
