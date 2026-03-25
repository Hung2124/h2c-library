<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Markdown Parser -->
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<button type="button" class="position-fixed sl-chat-fab"
        data-bs-toggle="offcanvas" data-bs-target="#slChatPanel"
        aria-label="Mở trợ lý thư viện">
    <i class="bi bi-chat-dots-fill" aria-hidden="true"></i>
    <span class="sl-chat-fab-badge d-none">1</span>
</button>

<!-- Chat offcanvas panel -->
<div class="offcanvas offcanvas-end sl-chat-panel"
     tabindex="-1" id="slChatPanel"
     aria-labelledby="slChatTitle">
    <div class="sl-chat-header">
        <div class="sl-chat-header-info">
            <div class="sl-chat-avatar">
                <i class="bi bi-book-fill" aria-hidden="true"></i>
            </div>
            <div>
                <h6 class="sl-chat-title mb-0" id="slChatTitle">Trợ lý thư viện</h6>
                <span class="sl-chat-status">
                    <span class="sl-chat-status-dot"></span>
                    Trực tuyến
                </span>
            </div>
        </div>
        <button type="button" class="sl-chat-close btn btn-sm btn-light"
                data-bs-dismiss="offcanvas" aria-label="Đóng">
            <i class="bi bi-x-lg" aria-hidden="true"></i>
        </button>
    </div>

    <div class="sl-chat-body" id="slChatBody">
        <div class="sl-chat-welcome" id="slChatWelcome">
            <div class="sl-chat-welcome-icon">
                <i class="bi bi-book" aria-hidden="true"></i>
            </div>
            <h6>Xin chào!</h6>
            <p>Tôi có thể giúp bạn tìm sách, hướng dẫn mượn sách, hoặc trả lời về quy định thư viện.</p>
        </div>
        <!-- Messages injected here -->
    </div>

    <div class="sl-chat-footer">
        <div class="sl-chat-input-row">
            <input type="text"
                   class="sl-chat-input"
                   id="slChatInput"
                   placeholder="Nhắn tin…"
                   maxlength="2000"
                   autocomplete="off">
            <button class="sl-chat-send-btn" type="button"
                    id="slChatSend" aria-label="Gửi">
                <i class="bi bi-arrow-up-circle-fill" aria-hidden="true"></i>
            </button>
        </div>
        <div class="sl-chat-error" id="slChatErr" role="alert"></div>
    </div>
</div>

<script>
(function () {
    const body     = document.getElementById('slChatBody');
    const welcome  = document.getElementById('slChatWelcome');
    const inp      = document.getElementById('slChatInput');
    const btn      = document.getElementById('slChatSend');
    const errEl    = document.getElementById('slChatErr');
    const ctx      = '${pageContext.request.contextPath}';

    function scrollBottom() {
        body.scrollTop = body.scrollHeight;
    }

    function appendMsg(role, text) {
        if (welcome) welcome.style.display = 'none';
        const wrap = document.createElement('div');
        wrap.className = 'sl-msg-wrap sl-msg-' + role;

        const bubble = document.createElement('div');
        bubble.className = 'sl-msg-bubble';
        if (role === 'bot') {
            const avatar = document.createElement('div');
            avatar.className = 'sl-msg-avatar';
            avatar.innerHTML = '<i class="bi bi-book-fill"></i>';
            
            // Render Markdown
            bubble.innerHTML = marked.parse(text);
            
            wrap.appendChild(avatar);
            wrap.appendChild(bubble);
        } else {
            bubble.textContent = text;
            wrap.appendChild(bubble);
        }
        body.appendChild(wrap);
        scrollBottom();
    }

    async function send() {
        const msg = (inp.value || '').trim();
        if (!msg) return;
        errEl.textContent = '';
        errEl.classList.remove('sl-chat-error--visible');
        appendMsg('user', msg);
        inp.value = '';
        btn.disabled = true;
        inp.disabled = true;
        try {
            const res = await fetch(ctx + '/api/gemini-chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: msg })
            });
            let data;
            const text = await res.text();
            try {
                data = JSON.parse(text);
            } catch (e) {
                data = { error: text || 'Phản hồi không hợp lệ từ server' };
            }

            if (!res.ok) {
                throw new Error(data.error || `Lỗi HTTP ${res.status}`);
            }
            appendMsg('bot', data.reply || '');
        } catch (e) {
            errEl.textContent = 'Lỗi trợ lý: ' + (e.message || 'Kết nối thất bại');
            errEl.classList.add('sl-chat-error--visible');
        } finally {
            btn.disabled = false;
            inp.disabled = false;
            inp.focus();
        }
    }

    btn.addEventListener('click', send);
    inp.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            send();
        }
    });
})();
</script>
