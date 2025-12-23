/**
 * Get current time in IST (Indian Standard Time)
 * IST is UTC+5:30
 * 
 * This function returns a Date object that represents the current IST time.
 * The Date object is created such that when stored in MongoDB (as UTC)
 * and later converted to IST for display, it will show the correct IST time.
 * 
 * @returns {Date} Date object representing current IST time
 */
function getISTTime() {
    const now = new Date();
    // Get the current UTC time in milliseconds
    const utcTime = now.getTime();
    
    // Get the server's timezone offset in minutes
    const serverOffset = now.getTimezoneOffset();
    
    // Convert to UTC milliseconds (remove server timezone offset)
    const utcMs = utcTime + (serverOffset * 60000);
    
    // Add IST offset (UTC+5:30 = +330 minutes)
    const istMs = utcMs + (330 * 60000);
    
    // Create a Date object from IST milliseconds
    // This Date represents the current IST time
    return new Date(istMs);
}

/**
 * Get today's date in IST (with time set to 00:00:00 IST)
 * 
 * @returns {Date} Date object representing today at 00:00:00 IST
 */
function getISTToday() {
    const istNow = getISTTime();
    
    // Get the IST date components (year, month, day)
    // We use UTC methods because the Date object represents IST time
    const year = istNow.getUTCFullYear();
    const month = istNow.getUTCMonth();
    const day = istNow.getUTCDate();
    
    // Create a Date object for midnight IST of today
    // We create it as if it's UTC midnight, then adjust for IST offset
    const utcMidnight = Date.UTC(year, month, day, 0, 0, 0, 0);
    
    // To represent midnight IST, we need to store (midnight - 5:30) UTC
    // So when this UTC time is converted to IST, it becomes midnight IST
    return new Date(utcMidnight - (330 * 60000));
}

module.exports = {
    getISTTime,
    getISTToday
};
