function result = uploadImageToThingSpeak
% Uploads a new image to a ThingSpeak image channel and a random value to
% the channel's field1 as a record of the timestamp when the code ran

    result = false;
    % grab the webcam image and write to ThingSpeak
    filename = 'beach.jpg';
    snapshotCamera(filename);
    imageUploadStatus = updateThingSpeakImageChannel(filename);
    
    if isequal(imageUploadStatus, true)
    % Write a random value to the channel's field 1 so we can track execution
        thingSpeakWrite(2597280, rand(1),'WriteKey','8A9XM15T7JGIUT6P');
        result = true;
    end      

    function result = updateThingSpeakImageChannel(filename)
        import matlab.net.http.*
        import matlab.net.http.field.*
        import matlab.net.http.io.*

        % Edit this section for your files. Timestamps are optional.
        channelId = '4cca1c2a79';
        channelApiKey = HeaderField('thingspeak-image-channel-api-key', 'OESKKGRHB2B7CMRY');

        provider = FileProvider(['./', filename]);
        req = RequestMessage(RequestMethod.POST, [channelApiKey], provider);
        url = ['https://data.thingspeak.com/channels/', channelId, '/images/', ...
            filename ];
        response = req.send(url);
        result = isequal(response.StatusCode, 202);
    end

    function snapshotCamera(filename)
        % snapshots the camera feed and stores it to the file specified by
        % filename.jpg
        eval("imshow(webread('http://80.28.111.68:82/axis-cgi/jpg/image.cgi',weboptions('ContentType','image')),'border','tight')");
        eval("text(5,50, sprintf('View of Urnieta, Spain at %s US ET on %s\nSee live at http://www.insecam.org/en/view/748176',datetime('now', 'Format','HH:mm'),datetime('now','Format','d MMMM y')))");
        ax=gca;
        exportgraphics(ax,filename)
    end

end
