function heading_change = calculate_heading_change(old,new)
    heading_change = abs(new-old);
    if heading_change > pi
        heading_change = 2*pi-heading_change;
    end
end

