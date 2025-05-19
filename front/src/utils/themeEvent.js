// In a new file: src/utils/themeEvent.js
export const themeEventBus = {
    listeners: {},

    on(event, callback) {
        if (!this.listeners[event]) {
            this.listeners[event] = []
        }
        this.listeners[event].push(callback)
    },

    emit(event, data) {
        if (this.listeners[event]) {
            this.listeners[event].forEach(callback => {
                callback(data)
            })
        }
    },

    off(event, callback) {
        if (this.listeners[event]) {
            if (callback) {
                this.listeners[event] = this.listeners[event].filter(
                    cb => cb !== callback
                )
            } else {
                delete this.listeners[event]
            }
        }
    }
}
