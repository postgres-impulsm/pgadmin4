##########################################################################
#
# pgAdmin 4 - PostgreSQL Tools
#
# Copyright (C) 2013 - 2015, The pgAdmin Development Team
# This software is released under the PostgreSQL Licence
#
##########################################################################

"""Utility functions for dealing with AJAX."""

from flask import Response
import json


def make_json_response(success=1, errormsg='', info='', result=None,
                       data=None, status=200):
    """Create a HTML response document describing the results of a request and
    containing the data."""
    doc = dict()
    doc['success'] = success
    doc['errormsg'] = errormsg
    doc['info'] = info
    doc['result'] = result
    doc['data'] = data

    return Response(
        response=json.dumps(doc),
        status=status,
        mimetype="text/json"
    )


def make_response(response=None, status=200):
    """Create a JSON response handled by the backbone models."""
    return Response(
        response=json.dumps(response),
        status=status,
        mimetype="text/json"
    )


def internal_server_error(errormsg=''):
    """Create a response with HTTP status code 500 - Internal Server Error."""
    return make_json_response(
                status=500,
                success=0,
                errormsg=errormsg
    )


def forbidden(errmsg=''):
    """Create a response with HTTP status code 403 - Forbidden."""
    return make_json_response(
            status=403,
            success=0,
            errormsg=errmsg
            )


def unauthorized(errormsg=''):
    """Create a response with HTTP status code 401 - Unauthorized."""
    return make_json_response(
                status=401,
                success=0,
                errormsg=errormsg
    )


def bad_request(errormsg=''):
    """Create a response with HTTP status code 400 - Bad Request."""
    return make_json_response(
                status=400,
                success=0,
                errormsg=errormsg
    )


def precondition_required(errormsg=''):
    """Create a response with HTTP status code 428 - Precondition Required."""
    return make_json_response(
                status=428,
                success=0,
                errormsg=errormsg
    )


def success_return(message=''):
    """Create a response with HTTP status code 200 - OK."""
    return make_json_response(
                status=200,
                success=1,
                info=message
    )