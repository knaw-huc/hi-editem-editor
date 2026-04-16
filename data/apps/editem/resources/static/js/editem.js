function doTEI() {
    q = prompt('which project?')
    url = '/app/editem/profile/clarin.eu:cr1:p_1772521921675/action/tei';
    if (q.trim()!='')
        url += '?q='+q;
    window.open(url, 'tei');
}