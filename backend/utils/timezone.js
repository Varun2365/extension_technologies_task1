/**
 * Get current time in IST (Indian Standard Time)
 * IST is UTC+5:30
 * Returns a Date object that represents the current IST time.
 * MongoDB stores dates in UTC, so this creates a Date that when
 * converted to IST will show the correct IST time.
 * 
 * @returns {Date} Date object representing current IST time
 */
function getISTTime() {
    const now = new Date();
    // Convert current time to UTC milliseconds
    const utcMs = now.getTime() + (now.getTimezoneOffset() * 60000);
    // Add IST offset (UTC+5:30 = +330 minutes)
    const istMs = utcMs + (330 * 60000);
    return new Date(istMs);
}

/**
 * Get today's date in IST (with time set to 00:00:00 IST)
 * Returns a Date object representing today at midnight IST.
 * 
 * @returns {Date} Date object representing today at 00:00:00 IST
 */
function getISTToday() {
    const istNow = getISTTime();
    // Get IST date components
    const year = istNow.getUTCFullYear();
    const month = istNow.getUTCMonth();
    const date = istNow.getUTCDate();
    
    // Create midnight IST as a Date object
    // Create UTC date and subtract IST offset to get the UTC time
    // that when displayed in IST shows midnight
    const utcMidnight = Date.UTC(year, month, date, 0, 0, 0, 0);
    // Subtract IST offset: if we want midnight IST, we store (midnight - 5:30) UTC
    return new Date(utcMidnight - (330 * 60000));
}

module.exports = {
    getISTTime,
    getISTToday
};

