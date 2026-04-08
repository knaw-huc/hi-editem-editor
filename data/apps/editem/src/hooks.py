from saxonche import PySaxonProcessor, PyXdmNode
from src.profiles import prof_xml
from fastapi import Request, Response, HTTPException
import toml
import os
import logging
from src.commons import settings, convert_toml_to_xml

def tei(req:Request, action:str, app: str, prof: str, nr: str, user:str) -> None:
    res = "This will be the response"
    with PySaxonProcessor(license=False) as proc:
        xsltproc = proc.new_xslt30_processor()
        xsltproc.set_cwd(os.getcwd())
        stylesheet=None;
        if prof == 'clarin.eu:cr1:p_1772521921675':
            stylesheet=f"{settings.URL_DATA_APPS}/{app}/resources/xslt/person-tei.xsl"
        if stylesheet:
            executable = xsltproc.compile_stylesheet(stylesheet_file=stylesheet)
            record_file = f"{settings.URL_DATA_APPS}/{app}/profiles/{prof}/records/record-{nr}.xml"
            with open(record_file, 'r') as file:
                rec = file.read()
                rec = proc.parse_xml(xml_text=rec)
                res = executable.transform_to_string(xdm_node=rec)
        else:
            res = "TODO"
    return Response(content=res, media_type="application/xml")

