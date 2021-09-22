from bokeh.embed import json_item, components
from bokeh.plotting import figure, curdoc
from bokeh.models.sources import AjaxDataSource, ColumnDataSource

#

from bokeh.models import CustomJS

bokeh_tool_tips = [
    ("index", "$index"),
    ("(x,y)", "($x, $y)"),
    # ("desc", "@desc"),
]

bokeh_tool_list = ['pan,wheel_zoom,lasso_select,reset']


def api_bokehinlinejs(data_url):
    streaming = True

    s1 = AjaxDataSource(data_url=data_url, polling_interval=1000, mode='append')

    s1.data = dict(x=[], y=[])

    s2 = ColumnDataSource(data=dict(x=[], y=[]))

    s1.selected.js_on_change(
        'indices',
        CustomJS(
            args=dict(s1=s1, s2=s2),
            code="""
        var inds = cb_obj.indices;
        var d1 = s1.data;
        var d2 = s2.data;
        d2['x'] = []
        d2['y'] = []
        for (var i = 0; i < inds.length; i++) {
            d2['x'].push(d1['x'][inds[i]])
            d2['y'].push(d1['y'][inds[i]])
        }
        s2.change.emit();
        
        """,
        ),
    )

    p1 = figure(
        x_range=(0, 10),
        y_range=(-1, 1),
        plot_width=400,
        plot_height=400,
        title="Streaming, take lasso to copy points (refresh after)",
        tools=bokeh_tool_list,
        tooltips=bokeh_tool_tips,
        name="p1",
    )
    p1.line('x', 'y', source=s1, color="blue", selection_color="green")
    p1.circle('x', 'y', size=1, source=s1, color=None, selection_color="red")

    p2 = figure(
        x_range=p1.x_range,
        y_range=(-1, 1),
        plot_width=400,
        plot_height=400,
        tools=bokeh_tool_list,
        title="Watch here catched points",
        tooltips=bokeh_tool_tips,
        name="p2",
    )
    p2.circle('x', 'y', source=s2, alpha=0.6)

    response_object = {}
    response_object['gr'] = {}

    script, div = components({'p1': p1, 'p2': p2}, wrap_script=False)
    response_object['gr']['script'] = script
    response_object['gr']['div'] = div
    return response_object
