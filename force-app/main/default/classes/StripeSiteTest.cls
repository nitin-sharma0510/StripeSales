@RestResource(urlmapping = '/StripeSiteTest/*')
global class StripeSiteTest {
	
    @HttpGet
    global static String getMethd()
    {
        return 'success';
    }
}