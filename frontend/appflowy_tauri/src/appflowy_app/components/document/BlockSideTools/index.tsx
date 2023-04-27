import React from 'react';
import { useBlockSideTools } from './BlockSideTools.hooks';
import ExpandCircleDownSharpIcon from '@mui/icons-material/ExpandCircleDownSharp';
import DragIndicatorRoundedIcon from '@mui/icons-material/DragIndicatorRounded';
import Portal from '../BlockPortal';
import { IconButton } from '@mui/material';
import BlockMenu from '../BlockMenu';

const sx = { height: 24, width: 24 };

export default function BlockSideTools(props: { container: HTMLDivElement }) {
  const { nodeId, ref, menuOpen, handleToggleMenu } = useBlockSideTools(props);

  if (!nodeId) return null;
  return (
    <>
      <Portal blockId={nodeId}>
        <div
          ref={ref}
          style={{
            opacity: 0,
          }}
          className='absolute left-[-50px] inline-flex h-[calc(1.5em_+_3px)] transition-opacity duration-500'
          onMouseDown={(e) => {
            // prevent toolbar from taking focus away from editor
            e.preventDefault();
          }}
        >
          <IconButton onClick={() => handleToggleMenu(true)} sx={sx}>
            <ExpandCircleDownSharpIcon />
          </IconButton>
          <IconButton sx={sx}>
            <DragIndicatorRoundedIcon />
          </IconButton>
        </div>
      </Portal>
      <BlockMenu open={menuOpen} onClose={() => handleToggleMenu(false)} nodeId={nodeId} />
    </>
  );
}