<!---

$Id$

Copyright (C) 2011 John Willis
 
This file is part of Prefiniti.

Prefiniti is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Prefiniti is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.

--->
<!---IDatatype.cfc $Revision: 1.2 $ --->
<cfinterface displayname="IDatatype">
	<cffunction name="Render" access="public" output="yes" returntype="void">
    	<cfargument name="turl" type="string" required="yes">
    	<cfargument name="fpath" type="string" required="yes">
        <cfargument name="width" type="numeric" required="yes">
        <cfargument name="height" type="numeric" required="yes">  
              
    </cffunction>                
</cfinterface>