<aura:application extends="force:slds">
    
    <lightning:input aura:id="txtEmail" type="email" name="email1" value="" label="Email field with predefined value" onblur="{!c.validate}" />
    
</aura:application>