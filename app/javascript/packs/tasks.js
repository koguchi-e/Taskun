document.addEventListener("DOMContentLoaded", () => {
    const modal = document.getElementById("commentModal");
    const closeBtn = document.querySelector(".close");
    const submitBtn = document.getElementById("submitComment");
    const commentInput = document.getElementById("commentInput");
    let currentTaskId = null;

    // `.task-checkbox` にイベントを委譲して2ページ目でも動作するようにする
    document.addEventListener("click", async (event) => {
        const target = event.target.closest(".task-checkbox");
        if (!target) return;

        const taskId = target.dataset.taskId;
        if (!taskId) return;

        const taskElement = target.closest(".index-results");
        const isCompleted = taskElement.classList.contains("completed-task");

        const confirmMessage = isCompleted ? "未完了に戻しますか？" : "完了報告しますか？";
        if (!confirm(confirmMessage)) return;

        try {
            const response = await fetch(`/tasks/${taskId}/complete`, {  // `toggle_complete` ではなく `complete` を使う
                method: "PATCH",
                headers: {
                    "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                    "Content-Type": "application/json"
                },
                credentials: "same-origin"
            });

            if (!response.ok) {
                throw new Error(`HTTPエラー! ステータス: ${response.status}`);
            }

            const data = await response.json();
            if (data.success) {
                console.log(`タスク ${taskId} の状態が更新されました`);

                taskElement.classList.toggle("completed-task");
                taskElement.querySelector("i.fa-circle-check").classList.toggle("completed-icon");
                taskElement.querySelector("b").classList.toggle("completed-text");

                if (!isCompleted) {
                    currentTaskId = taskId;
                    modal.style.display = "block";
                }
            } else {
                console.error("サーバーエラー:", data.error || data.errors);
                alert("エラーが発生しました: " + (data.error || data.errors.join(", ")));
            }
        } catch (error) {
            console.error("Fetchエラー:", error);
            alert("タスクの状態変更に失敗しました。");
        }
    });

    submitBtn.addEventListener("click", async () => {
        if (!currentTaskId) {
            console.error("タスクIDがセットされていません");
            return;
        }

        const comment = commentInput.value.trim();
        if (!comment) {
            alert("コメントを入力してください");
            return;
        }

        try {
            const response = await fetch(`/tasks/${currentTaskId}/comment`, {
                method: "POST",
                headers: {
                    "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                    "Content-Type": "application/json"
                },
                credentials: "same-origin",
                body: JSON.stringify({ comment: comment })
            });

            if (!response.ok) {
                throw new Error(`HTTPエラー! ステータス: ${response.status}`);
            }

            const data = await response.json();
            if (data.success) {
                alert("コメントが追加されました！");
                modal.style.display = "none";
                commentInput.value = "";
            } else {
                console.error("コメント送信エラー:", data.errors);
                alert("エラーが発生しました: " + data.errors.join(", "));
            }
        } catch (error) {
            console.error("Fetchエラー:", error);
            alert("コメントの送信に失敗しました。");
        }
    });

    closeBtn.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (event) => {
        if (event.target === modal) {
            modal.style.display = "none";
        }
    });
});
