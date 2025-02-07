const { event } = require("jquery")

document.addEventListener("DOMContentLoaded",() =>{
    document.querySelectorAll(".task-checkbox").forEach((checkbox) => {
        checkbox.addEventListener("click", (event) => {
            const taskId = event.currentTarget.dataset.taskId;
            
            if (confirm("完了報告しますか？")) {
                fetch(`/tasks/${taskId}/complete`,{
                    method: "PATCH",
                    headers: {
                        "X-CSRF-Token" :document.querySelector("meta[name='csrf-token']").content,
                        "Content-Type": "application/json"
                    },
                    credentials: "same-origin"
                })
            
                .then(response => response.json())
                .then(data =>{
                    if(data.success){
                        const taskElement = event.currentTarget.closest(".index-results")
                        taskElement.classList.add("completed-task");
                        taskElement.querySelector("i.fa-circle-check").classList.add("completed-icon");
                        taskElement.querySelector("b").classList.add("completed-text");
                    }
                });
            }
        });
    });
});
