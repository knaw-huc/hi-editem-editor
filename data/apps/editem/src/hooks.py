from saxonche import PySaxonProcessor, PyXdmNode
from src.profiles import prof_xml
from fastapi import Request, Response, HTTPException
import os
import logging
from src.commons import settings, convert_toml_to_xml

def tei(req:Request, action:str, app: str, prof: str, nr: str, user:str) -> None:
    logging.info(f'TEI hook action[{action}] app[{app}] prof[{prof}] nr[{nr}] user[{user}]')
    res = "This will be the response"
    with PySaxonProcessor(license=False) as proc:
        xsltproc = proc.new_xslt30_processor()
        xsltproc.set_cwd(os.getcwd())
        stylesheet=None;
        if prof == 'clarin.eu:cr1:p_1772521921675':
            stylesheet=f"{settings.URL_DATA_APPS}/{app}/resources/xslt/person-tei.xsl"
        if stylesheet:
            executable = xsltproc.compile_stylesheet(stylesheet_file=stylesheet)
            rec = proc.parse_xml(xml_text="<null/>")
            if nr:
                record_file = f"{settings.URL_DATA_APPS}/{app}/profiles/{prof}/records/record-{nr}.xml"
                with open(record_file, 'r') as file:
                    rec = file.read()
                    rec = proc.parse_xml(xml_text=rec)
            else:
                args = dict(req.query_params)
                if 'q' in args:
                    executable.set_parameter("q", proc.make_string_value(args['q']))
                executable.set_parameter("cwd", proc.make_string_value(os.getcwd()))
                executable.set_parameter("app", proc.make_string_value(app))
                executable.set_parameter("prof", proc.make_string_value(prof))
            res = executable.transform_to_string(xdm_node=rec)
        else:
            res = "TODO"
    return Response(content=res, media_type="application/xml")

