describe("Test props and methods of global function, Debugger: \n", function() {
 
    beforeEach(function(){
        Debugger.on = true;
    });
 
    afterEach(function() {
        Debugger.on = false;
    });
 
    it("Should exist...\n", function() {
        expect( typeof Debugger ).toBe( 'function' );
    });
 
    it("Should print argument to console...\n", function() {
        expect( typeof Debugger.log( "Hello, String" ) ).toBe( 'string' );
        expect( typeof Debugger.log( {'Hello': "Object"} ) ).toBe( 'object' );
        expect( typeof Debugger.log( {'Subsitution': "Object"}, "Hello, $1" ) ).toBe( 'object' );
    });
	
	return true;
});
