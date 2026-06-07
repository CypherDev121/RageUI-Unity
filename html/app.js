;(function() {
    'use strict'

    const UI = {
        menuVisible: false,
        selectedIndex: 1,
        itemCount: 0,
        currentMenu: null,
        notifId: 0,
        notifs: [],

        init() {
            this.cache = {
                menu: document.getElementById('rageui-menu'),
                title: document.getElementById('menu-title'),
                subtitle: document.getElementById('menu-subtitle-text'),
                subtitleCount: document.getElementById('menu-subtitle-count'),
                items: document.getElementById('menu-items'),
                desc: document.getElementById('menu-description'),
                descText: document.getElementById('menu-desc-text'),
                notifications: document.getElementById('rageui-notifications'),
                information: document.getElementById('rageui-information'),
                infoHeader: document.getElementById('info-header'),
                infoItems: document.getElementById('info-items'),
            }

            window.addEventListener('message', (e) => this.onMessage(e.data || e))
        },

        /* ─── Helper for GTA Colors ─── */
        parseColors(str) {
            if (!str) return '';
            let text = this.esc(str);
            const colorMap = {
                '~r~': '#ff3333',
                '~g~': '#33ff33',
                '~b~': '#3333ff',
                '~y~': '#ffff33',
                '~p~': '#ff33ff',
                '~o~': '#ffaa33',
                '~c~': '#aaaaaa',
                '~m~': '#555555',
                '~u~': '#000000',
                '~w~': '#ffffff',
                '~s~': 'inherit',
            };
            
            // Unescape HTML tags so users can use FontAwesome icons like <i class="..."></i>
            text = text.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#039;/g, "'");

            for (const [code, color] of Object.entries(colorMap)) {
                const regex = new RegExp(code, 'gi');
                text = text.replace(regex, `</span><span style="color:${color}">`);
            }
            
            text = text.replace(/~[a-z]~/gi, '');
            return `<span>${text}</span>`;
        },

        /* ─── Message handler ─── */
        onMessage(data) {
            if (!data || !data.type) return

            switch (data.type) {

                case 'rageui:render':
                    this.renderMenu(data)
                    break

                case 'rageui:hide':
                    this.hide()
                    break

                case 'rageui:select':
                    this.setSelected(data.index || 1)
                    break

                case 'rageui:notify':
                    this.showNotification(data.text || '', data.style || 'info', data.duration || 4000)
                    break

                case 'rageui:updateItem':
                    this.updateItem(data.index, data.data || {})
                    break

                case 'rageui:showIdCard':
                    this.showIdCard(data.data || {})
                    break

                case 'rageui:hideIdCard':
                    this.hideIdCard()
                    break

                case 'rageui:renderInformation':
                    this.renderInformation(data)
                    break

                case 'rageui:hideInformation':
                    this.hideInformation()
                    break

                case 'rageui:updateColors':
                    this.updateColors(data.colors)
                    break
            }
        },

        /* ─── Update CSS Variables ─── */
        updateColors(colors) {
            if (!colors) return;
            const root = document.documentElement;
            for (const [key, value] of Object.entries(colors)) {
                root.style.setProperty(`--${key}`, value);
            }
        },

        /* ─── Information Panel ─── */
        renderInformation(data) {
            if (!data || !data.items) return;
            
            this.cache.infoHeader.innerHTML = this.parseColors(data.title || 'Informations');
            
            let html = '';
            for (const item of data.items) {
                const label = this.parseColors(item.label || '');
                const val = this.parseColors(item.value || '');
                html += `
                    <div class="info-item">
                        <span class="info-label">${label}</span>
                        <span class="info-value">${val}</span>
                    </div>
                `;
            }
            
            if (this.cache.infoItems) this.cache.infoItems.innerHTML = html;
            if (this.cache.information) this.cache.information.classList.remove('hidden');
        },

        hideInformation() {
            if (this.cache.information) this.cache.information.classList.add('hidden');
        },

        /* ─── Render entire menu ─── */
        renderMenu(data) {
            if (!data || !data.items) {
                this.hide()
                return
            }

            this.currentMenu = data
            this.selectedIndex = data.index || 1
            this.itemCount = data.items.length

            this.cache.title.textContent = data.title || 'Menu'
            this.cache.subtitle.textContent = (data.subtitle || 'Interagir').replace(/~u~/g, '')

            if (this.cache.subtitleCount) {
                this.cache.subtitleCount.textContent = `(${this.selectedIndex} / ${this.itemCount})`
            }

            this.buildItems(data.items)
            this.show()
        },

        /* ─── Build items list ─── */
        buildItems(items, maxItems) {
            const container = this.cache.items
            container.innerHTML = ''

            if (!items || items.length === 0) {
                container.innerHTML = '<div class="menu-item" style="justify-content:center;color:#555;font-size:12px">Aucun élément</div>'
                if (this.cache.desc) this.cache.desc.classList.add('hidden')
                return
            }

            maxItems = maxItems || 10;
            let start = 0;
            let end = items.length;
            
            if (items.length > maxItems) {
                let half = Math.floor(maxItems / 2);
                if (this.selectedIndex <= half + 1) {
                    start = 0;
                    end = maxItems;
                } else if (this.selectedIndex > items.length - half) {
                    start = items.length - maxItems;
                    end = items.length;
                } else {
                    start = this.selectedIndex - half - 1;
                    end = start + maxItems;
                }
            }

            let slicedItems = items.slice(start, end);

            let html = ''
            for (let i = 0; i < slicedItems.length; i++) {
                const item = slicedItems[i]
                const idx = start + i + 1
                const sel = (idx === this.selectedIndex)
                const type = item.type || 'button'
                const disabled = item.disabled ? ' disabled' : ''
                const selected = sel ? ' selected' : ''

                let cls = `menu-item ${type}${selected}${disabled}`
                let label = this.parseColors(item.label || '')
                let right = this.parseColors(item.rightLabel || '')
                let extra = ''

                switch (type) {
                    case 'separator':
                        cls += label ? '' : ' empty'
                        break

                    case 'checkbox':
                        extra = item.checked ? ' checked' : ''
                        break

                    case 'list':
                        right = `◄ ${this.parseColors(item.listValue || '')} ►`
                        break

                    case 'slider':
                        right = `${item.value || 0}%`
                        break

                    case 'progress':
                        right = `${Math.floor((item.value || 0) / (item.max || 100) * 100)}%`
                        break

                    case 'badge':
                        break
                }

                html += `<div class="${cls}" data-index="${idx}" data-type="${type}"${extra}>`

                // Inject Progress/Slider Background Bar
                if (type === 'slider' || type === 'progress') {
                    const min = item.min || 0;
                    const max = item.max || 100;
                    const val = item.value || 0;
                    const pct = Math.max(0, Math.min(100, ((val - min) / (max - min)) * 100));
                    html += `<div class="menu-item-progress" style="width: ${pct}%"></div>`;
                }

                // Checkbox: icon on left matches state
                if (type === 'checkbox') {
                    const cbIcon = item.checked ? 'fa-toggle-on' : 'fa-toggle-off';
                    html += `<span class="menu-item-icon"><i class="fa-solid ${cbIcon}"></i></span>`;
                }

                html += `<span class="menu-item-label">${label}</span>`

                // Right components
                if (type === 'checkbox') {
                    // Native-style checkbox indicator on the right
                    html += `<span class="menu-checkbox${item.checked ? ' checked' : ''}"></span>`
                } else if (type === 'button' || type === 'button_colored') {
                    html += `<div class="menu-item-right-container">`;
                    const cleanRight = item.rightLabel ? String(item.rightLabel).replace(/~[a-z]~/gi, '').trim() : '';
                    if (cleanRight && cleanRight !== '→' && cleanRight !== '➔' && cleanRight !== '▶' && cleanRight !== '>' && cleanRight !== '>>') {
                        html += `<span class="menu-item-right-label">${right}</span>`;
                    }
                    if (cleanRight === '🔒' || item.rightLabel === '🔒') {
                        html += `<span class="menu-item-arrow-box"><i class="fa-solid fa-lock"></i></span>`;
                    } else if (cleanRight !== '') {
                        html += `<span class="menu-item-arrow-box"><i class="fa-solid fa-chevron-right"></i></span>`;
                    }
                    html += `</div>`;
                } else if (right) {
                    html += `<span class="menu-item-right">${right}</span>`
                }

                html += `</div>`
            }

            container.innerHTML = html

            const itemsEl = container.querySelectorAll('.menu-item')
            itemsEl.forEach(el => {
                el.addEventListener('click', () => {
                    const idx = parseInt(el.dataset.index)
                    if (!isNaN(idx)) {
                        this.clickItem(idx)
                    }
                })
                el.addEventListener('mouseenter', () => {
                    const idx = parseInt(el.dataset.index)
                    if (!isNaN(idx)) {
                        this.hoverItem(idx)
                    }
                })
            })

            this.showDescription()
            this.scrollToSelected()
        },

        /* ─── Show/hide ─── */
        show() {
            this.menuVisible = true
            this.cache.menu.classList.remove('hidden')
            this.cache.menu.classList.add('visible')
        },

        hide() {
            this.menuVisible = false
            this.cache.menu.classList.remove('visible')
            this.cache.menu.classList.add('hidden')
            this.currentMenu = null
            this.hideInformation()
        },

        /* ─── ID Card ─── */
        showIdCard(data) {
            const container = document.getElementById('rageui-idcard-container');
            if (!container) return;

            document.getElementById('idcard-lastname').textContent = data.lastname || 'DOE';
            document.getElementById('idcard-firstname').textContent = data.firstname || 'JOHN';
            document.getElementById('idcard-dob').textContent = data.dob || '01/01/1990';
            document.getElementById('idcard-sex').textContent = data.sex || 'M';
            document.getElementById('idcard-height').textContent = data.height ? data.height + ' cm' : '180 cm';
            document.getElementById('idcard-signature').textContent = data.firstname + ' ' + data.lastname;

            container.classList.remove('hidden');
        },

        hideIdCard() {
            const container = document.getElementById('rageui-idcard-container');
            if (container) container.classList.add('hidden');
        },

        /* ─── Selection ─── */
        setSelected(index) {
            this.selectedIndex = index

            const items = this.cache.items.querySelectorAll('.menu-item')
            items.forEach(el => {
                const idx = parseInt(el.dataset.index)
                el.classList.toggle('selected', idx === index)
            })

            if (this.cache.subtitleCount && this.itemCount > 0) {
                this.cache.subtitleCount.textContent = `(${this.selectedIndex} / ${this.itemCount})`
            }

            this.showDescription()
            this.scrollToSelected()
        },

        /* ─── Scroll to keep selected visible ─── */
        scrollToSelected() {
            const container = this.cache.items
            const sel = container.querySelector('.menu-item.selected')
            if (!sel) return

            const cRect = container.getBoundingClientRect()
            const sRect = sel.getBoundingClientRect()

            if (sRect.top < cRect.top) {
                container.scrollTop -= (cRect.top - sRect.top) + 8
            } else if (sRect.bottom > cRect.bottom) {
                container.scrollTop += (sRect.bottom - cRect.bottom) + 8
            }
        },

        /* ─── Description ─── */
        showDescription() {
            const menu = this.currentMenu
            if (!menu || !menu.items) {
                this.cache.desc.classList.add('hidden')
                return
            }

            const item = menu.items[this.selectedIndex - 1]
            if (item && item.description) {
                this.cache.descText.textContent = item.description
                this.cache.desc.classList.remove('hidden')
            } else {
                this.cache.desc.classList.add('hidden')
            }
        },

        /* ─── Item click → NUI callback ─── */
        clickItem(index) {
            this.send('selectItem', { index })
        },

        hoverItem(index) {
            this.send('hoverItem', { index })
        },

        /* ─── Update single item (checkbox, slider, list...) ─── */
        updateItem(index, data) {
            if (!this.currentMenu || !this.currentMenu.items) return
            const item = this.currentMenu.items[index - 1]
            if (!item) return

            if (data.checked !== undefined) item.checked = data.checked
            if (data.value !== undefined) item.value = data.value
            if (data.label !== undefined) item.label = data.label
            if (data.description !== undefined) item.description = data.description
            if (data.rightLabel !== undefined) item.rightLabel = data.rightLabel
            if (data.disabled !== undefined) item.disabled = data.disabled

            const el = this.cache.items.querySelector(`.menu-item[data-index="${index}"]`)
            if (!el) return

            if (item.type === 'checkbox') {
                const cb = el.querySelector('.menu-checkbox')
                if (cb) {
                    cb.classList.toggle('checked', item.checked)
                }
            }

            const labelEl = el.querySelector('.menu-item-label')
            if (labelEl && data.label !== undefined) {
                labelEl.textContent = data.label
            }

            if (data.disabled !== undefined) {
                el.classList.toggle('disabled', data.disabled)
            }

            if (index === this.selectedIndex) {
                this.showDescription()
            }
        },

        /* ─── Notification ─── */
        showNotification(text, style, duration) {
            const container = this.cache.notifications
            if (!container) return

            const id = ++this.notifId
            if (this.notifs.length >= 5) {
                const old = this.notifs.shift()
                const el = document.getElementById(`n-${old}`)
                if (el) el.remove()
            }

            const clean = text.replace(/~[rgbypoushw~]/g, '')
            const titles = { info: 'INFO', success: 'SUCCÈS', error: 'ERREUR', warning: 'ATTENTION' }
            const t = titles[style] || 'INFO'

            const div = document.createElement('div')
            div.className = `notification ${style}`
            div.id = `n-${id}`
            div.innerHTML = `<div class="n-title">${t}</div><div class="n-text">${clean}</div>`
            container.appendChild(div)

            this.notifs.push(id)

            setTimeout(() => {
                const el = document.getElementById(`n-${id}`)
                if (el) { el.remove(); this.notifs = this.notifs.filter(x => x !== id) }
            }, duration || 4000)
        },

        /* ─── Send to Lua ─── */
        send(action, data = {}) {
            const resourceName = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : window.location.hostname;
            fetch(`https://${resourceName}/rageui`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ action, ...data })
            }).catch(() => {})
        },

        /* ─── Escape HTML ─── */
        esc(str) {
            if (!str) return ''
            const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' }
            return String(str).replace(/[&<>"']/g, c => map[c])
        }
    }

    document.addEventListener('DOMContentLoaded', () => UI.init())

})()
