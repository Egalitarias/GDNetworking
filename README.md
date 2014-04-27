GDNetworking
============

Simple json networking library for iOS.


Simple http get example:

<pre>
-(IBAction)getButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    GDRequest *request = [[GDRequest alloc] init];
    
    NSDictionary *dictionary = @{@"url" : _urlTextField.text, @"method" : @"GET"};
    [request submitRequestUsingDictionary:dictionary delegate:self];
}

-(void)successUpdate:(NSDictionary *)request response:(NSDictionary *)response {
    NSNumber *statusCodeNumber = [response objectForKey:@"statusCode"];
    int statusCode = [statusCodeNumber intValue];
    NSString *text = [[NSString alloc] initWithFormat:@"Success: %d", statusCode];
    [_statusCodeTextView setText:text];
    
    NSDictionary *body = [response objectForKey:@"body"];
    text = [[NSString alloc] initWithFormat:@"Success: %@", body];
    [_responseTextView setText:text];
    
}

-(void)failUpdate:(NSDictionary *)request response:(NSDictionary *)response error:(NSError *)error {
    NSNumber *statusCodeNumber = [response objectForKey:@"statusCode"];
    int statusCode = [statusCodeNumber intValue];
    NSString *text = [[NSString alloc] initWithFormat:@"Fail: %d", statusCode];
    [_statusCodeTextView setText:text];
}

</pre>

Simple http put example:

<pre>
- (void)registerUserUsingDictionary:(NSDictionary *)parameters delegate:(id<UpdateDelegate>)delegate {
    NSString *url = @"https://www.yourdomain.com:12345/User/Register";
    NSDictionary *requestParameters = @{@"url" : url, @"method" : @"PUT" , @"headers" : @{@"Content-Type" : @"application/json; charset=utf-8"}, @"parameters" : parameters};
    
    APIRequest *request = [[APIRequest alloc] init];
    [request submitRequestUsingDictionary:requestParameters delegate:delegate];
}

</pre>

Login example using http post:

<pre>
// example parameters: NSDictionary *parameters = @{@"Email" : emailText, @"Password" : passwordText};
- (void)loginUsingDictionary:(NSDictionary *)parameters delegate:(id<UpdateDelegate>)delegate {
    NSString *url = @"https://www.yourdomain.com:12345/User/Login";
    NSDictionary *requestParameters = @{@"url" : url, @"method" : @"POST" , @"headers" : @{@"Content-Type" : @"application/json; charset=utf-8"}, @"parameters" : parameters};
    
    APIRequest *request = [[APIRequest alloc] init];
    [request submitRequestUsingDictionary:requestParameters delegate:delegate];
}

</pre>

Simple http delete example:

<pre>
- (void)deleteUserUsingDictionary:(NSDictionary *)parameters delegate:(id<UpdateDelegate>)delegate {
    NSString *url = @"https://www.yourdomain.com:12345/User/Delete"];
    NSString *basicAuthentication = [self makeAuthorization];
    NSDictionary *requestParameters = @{@"url" : url, @"method" : @"DELETE" , @"headers" : @{@"Content-Type" : @"application/json; charset=utf-8", @"Authorization" : basicAuthentication}, @"parameters" : parameters};
    
    APIRequest *request = [[APIRequest alloc] init];
    [request submitRequestUsingDictionary:requestParameters delegate:delegate];
}
</pre>
